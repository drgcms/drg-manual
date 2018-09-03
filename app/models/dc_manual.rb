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

##########################################################################
# DcManual model definition. DcManual defines common data for manual document.
##########################################################################
class DcManual
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title ,      type: String
  field :link,        type: String
  field :description, type: String
  field :body,        type: String
  field :picture,     type: String
  field :author,      type: String
  field :order,       type: Integer, default: 10
  field :policy_id,   type: BSON::ObjectId  
  field :active,      type: Boolean, default: true
  field :menu,        type: String
  field :css,         type: String

  embeds_many :dc_manual_pages
  
  index( { link: 1 } )
  
  validates :title,       presence: true
  validates :description, presence: true  
  
  before_save :do_before_save

######################################################################
# Update befoer save
######################################################################
def do_before_save
# update link  
  if self.link.blank?
    self.link = DcManual.clear_link( self.title.downcase.strip ) 
  end
# Prepare menu_data for caching menu. Save as tab delimited
  self.menu = DcManual.update_menu(self).inject('') {|result, element| result << element.join("\t") + "\n"}
end

######################################################################
# Returns menu data suitable for choices in tree_select DRGCMS field
######################################################################
def choices4_all_as_tree(all=false)
  all ? DcManual.get_menu_all() : DcManual.get_menu(self)
end

protected

##########################################################################
# Strip unwante characters from link and trim it to 100 chars 
##########################################################################
def self.clear_link(link)
  link.gsub!(/\+|\–|\.|\?|\!\&|»|«|\,|\"|\'|\%|\:|\/|\(|\)/,'')
  link.chomp!()
  link.gsub!(' ','-')
  link.squeeze!('-')
  link = link[0,100]
  ix = link.size
  ix = link.rindex('-') if ix == 100  
  link[0,ix]
end

#######################################################################
# Do one subpage
#######################################################################
def self.do_sub_page(pages, parent, ids) #:nodoc:
  result = []
  pages.each do |page|
    next unless page.active
    long_id   = "#{ids};#{page.id}"
    result   << [page.title, long_id, parent, page.order, page.link]
    sub_pages = page.dc_manual_pages.order_by(order: 1).to_a
    result   += self.do_sub_page(sub_pages, long_id, long_id) if sub_pages.size > 0
  end
  result
end

######################################################################
# Update cached menu 
######################################################################
def self.update_menu(document)
  pages   = document.dc_manual_pages.only(:id, :order, :title, :link).order_by(order: 1).to_a
  result  = [[document.title, document.id, '', 0, document.link]]
  result += self.do_sub_page(pages, document.id, document.id ) if pages.size > 0
  result.sort{|a,b| a[2] <=> b[2]}
end

######################################################################
# Returns menu for single manual
######################################################################
def self.get_menu(manual)
  manual.menu.split("\n").each.inject([]) do |result, line|
    result += [line.split("\t")]
  end
end

######################################################################
# Returns menu for all manuals
######################################################################
def self.get_all_menus()
  manuals = self.only(:menu).where(active: true).order_by(title: 1).to_a
  manuals.inject([]) { |result, manual| result += self.get_menu(manual) }
end

end
