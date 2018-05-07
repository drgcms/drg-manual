# DrgBooks

DrgBooks plugin implements documentation management in DRG CMS enabled web site.

Configuration
----------------

Usage:

Add this line to your Gemfile:
```ruby
  gem 'drg_books'
```  

Create apropriate dc_page document with related design. Use this line in design.
```irb
div id="docs"><%= dc_render(:dc_book) %></div>
```

Update routes.rb
```ruby
  get '/books/:method/:book_id/', to: 'dc_main#page', :defaults => { path: 'books' }
  get '/books/:method/:book_id/:chapter_id', to: 'dc_main#page', :defaults => { path: 'books' }
  get '/books/:method/:book_id/:chapter_id/:version', to: 'dc_main#page', :defaults => { path: 'books' }
```

Documentation
-------------

Please see the DRG CMS website for up-to-date documentation:
[www.drgcms.org](http://www.drgcms.org)

License
-------

Copyright (c) 2012-2015 Damjan Rems

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Credits
-------

Damjan Rems: damjan dot rems at gmail dot com
