#coding: utf-8
#--
# Copyright (c) 2018+ Damjan Rems
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

########################################################################
# 
########################################################################
class DcManualRenderer
include DcApplicationHelper

########################################################################
#
########################################################################
def initialize( parent, opts={} )
  @parent = parent
  @opts   = opts
  self
end

#########################################################################
# List all manuals
########################################################################
def list
  html = "<div class='#{@opts[:div] || 'list-manuals'}'>"
  if @opts[:edit_mode] > 1
    html << dc_link_for_create({ controller: 'cmsedit', table: 'dc_manual', title: t('dc_manual.new') }) 
  end
  manuals = DcManual.where(active: true).sort(title: 1).to_a
  html << @parent.render( partial: 'dc_manual/list', locals: { manuals: manuals }, formats: [:html] )
  html << '</div>'
end

########################################################################
# Find document.
########################################################################
def find_document
# found bookname in path link 
  book_name_ix = @path.index(@parent.page.link)
  @manual      = DcManual.find_by(link: @path[book_name_ix+1])
  if @manual
    @prepand_path = @path.shift(book_name_ix+2)
  else
# manual_id should be set in page settings   
    manual_id  = @opts.dig(:settings, 'manual', 'manual_id')
    @prepand_path = @path.shift(book_name_ix+1)
    @manual       = DcManual.find(manual_id) if manual_id
  end  
  return if @manual.nil?
# ids for editing manual page
  @manual_ids  = '' 
# Determine selected page
  @manual_page = @manual
  while (link_page = @path.shift) != nil do
    @manual_ids << (@manual_ids.blank? ? '' : ';') + "#{@manual_page.id}"
    @manual_page = @manual_page.dc_manual_pages.find_by(link: link_page)
    if @manual_page.nil?
# select first page if path is in error    
      @manual_page = @manual
      break 
    end      
  end
end

########################################################################
# Create link for one page
########################################################################
def menu_link_for(menu, parent_path)
  document_link = parent_path + [menu[4]]
  document_link.shift # remove link to document name
  link = "/#{@prepand_path.join('/')}/#{document_link.join('/')}"
  @parent.link_to(menu[0],link)
end

########################################################################
# Create submenus for a menu
########################################################################
def submenu(menu_item, menu, parent_path)
# is active when ids path matches parent path or last (my id) matches manual_page
  last_item = menu_item[1].split(';').last
  is_active = (@manual_ids.match(menu_item[1]) or last_item.match(@manual_page.id.to_s)) ? ' is-active' : '' 
  
  html = parent_path.blank? ? '' : "<li class=\"#{is_active}\">#{menu_link_for(menu_item, parent_path)}" 
# select subpages  
  sub_pages = menu.select {|e| e[2] == menu_item[1]}
  return html if sub_pages.size == 0
#  
  sub_pages.sort! {|a,b| a[3] <=> b[3]}
  sub_pages.each do |page|
    html << %Q[<ul class="menu vertical nested #{is_active}" >]
    html << submenu(page, menu, parent_path + [menu_item[4]] )
    html << '</ul>'
  end
  html << '</li>'
end

########################################################################
# Create menu 
########################################################################
def manual_menu
  menu = @manual.choices4_all_as_tree    
  html = "<div class=\"title\">#{menu_link_for(menu.first,[])}</div>"
  html << submenu(menu.first, menu, [])
%Q[<ul id="manual-menu" class="is-active menu multilevel-accordion-menu " data-accordion-menu data-submenu-toggle="true">
  #{html}
</ul>]
end

#######################################################################
# Render manual data
#######################################################################
def default
  @path = @opts[:path]
  return list if @path.size == 1 
# link for manual settings on the page  
  edit_html = ''
  if dc_edit_mode?
    edit_html << @parent.dc_link_for_edit(table: 'dc_memory', title: 'dc_manual.settings', 
                             form_name: 'dc_manual_settings', icon: 'book lg', 
                             location: @parent.page.class.to_s,
                             field_name: 'params', id: @parent.page.id,
                             action: 'new', element: 'manual' )
  end
  find_document()
  return "ERROR! #{@parent.params[:path]} #{edit_html}" if @manual.nil? or @manual_page.nil?
#  
  if dc_edit_mode?
    opts = { action: 'edit', table: 'dc_manual', 
             id: @manual._id, title: 'dc_manual.edit' }
    edit_html << dc_link_for_edit(opts)    
  end
#
  html = %Q[
<div class="wrap">
<div class="row manual">
  <div class="column small-12 medium-3 large-4">
    #{edit_html}#{manual_menu()}
  </div>
  <div class="column small-12 medium-9 large-8 body">]
#
# ;add dc_manual_pages 
  no_subsections = @manual_ids.split(';').size
  table = 'dc_manual' + ';dc_manual_page'*no_subsections
  form_name = @manual_ids.blank? ? 'dc_manual' : 'dc_manual_page'
  if dc_edit_mode?
    unless @manual_ids.blank?
      opts = { action: 'edit', form_name: form_name, table: table,
               ids: @manual_ids, 'id' => @manual_page.id, 
               title: I18n.t('dc_manual.edit_chapter', title: @manual_page.title) }
      html << dc_link_for_edit(opts) + '<br>'.html_safe
    end
# Add new subchapter
    ids = @manual_ids + (@manual_ids.blank? ? '' : ';') + @manual_page.id.to_s
    table = 'dc_manual' + ';dc_manual_page'*(no_subsections+1)
    opts = { controller: 'cmsedit', action: 'new', form_name: 'dc_manual_page', 
             table: table, ids: ids, 
             title: I18n.t('dc_manual.new_chapter', title: @manual_page.title) }
    html << dc_link_for_create(opts) + '<br>'.html_safe  
  end
#    
  can_view, msg = dc_user_can_view(@parent, @manual_page)
  html << if can_view
%Q[<h1>#{@manual_page.title}</h1>#{@manual_page.body}<br>
<div class='updated'>
  #{t('dc_manual.updated')} <b>#{@manual_page.updated_at.strftime('%d.%m.%Y')}</b>
</div>]
  else
    msg
  end
  html << '</div></div></div>'
end

########################################################################
#
########################################################################
def render_html
  method = @opts[:method] || 'default'
  return "#{self.class}. Method #{method} not defined!" unless method
  
  send method
end

########################################################################
#
########################################################################
def render_css
  @manual.try :css
end

end
