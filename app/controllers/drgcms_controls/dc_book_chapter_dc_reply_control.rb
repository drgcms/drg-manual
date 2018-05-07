#encoding: utf-8
#--
# Copyright (c) 2014+ Damjan Rems
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

######################################################################
# DrgcmsControls for DcBlog.DcReply form
######################################################################
module DrgcmsControls::DcBookChapterDcReplyControl

######################################################################
# Called when new empty record is created
######################################################################
def dc_new_record()
# fill with quote when reply_to is present  
  if params[:reply_to]
    replyto = @record._parent.dc_replies.find(params[:reply_to])
    @record.subject = "Re: #{replyto.subject}"
    @record.body = "<div class='dc-forum-quote'>#{replyto.body}</div><br>"
  end
  @record.created_by_name = session[:user_name] if session[:user_name]
end

######################################################################
# Called before save. Reloads browser.
######################################################################
def dc_before_save()
  params[:return_to] = 'parent.reload'
end

end 
