#--
# Copyright (c) 2018 Damjan Rems
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

class DcManualPage
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title,       type: String
  field :link,        type: String
  field :use_page,    type: BSON::ObjectId
  field :body,        type: String
  field :picture,     type: String
  field :author,      type: String
  field :order,       type: Integer
  field :policy_id,   type: BSON::ObjectId  
  field :active,      type: Boolean, default: true
  
  index( { link: 1 } )

  embeds_many :dc_manual_pages, :cyclic => true
  
  validates :title, presence: true  
  
  before_save   :do_before_save
  after_save    :update_menu
  after_destroy :update_menu

protected

######################################################################
#
######################################################################
def do_before_save
  if self.link.blank?
    self.link = DcManual.clear_link( self.title.downcase.strip ) 
  end
end

######################################################################
# Update manual menu after page has been saved
######################################################################
def update_menu
  parent = self._parent
  while parent.class != DcManual do 
    parent = parent._parent 
  end
  parent.do_before_save
  parent.save
end

end
