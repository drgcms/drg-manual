# DrgManual

DrgManual implements documentation manual web element for DRG CMS.

##Usage:

Add this line to your Gemfile:

```ruby
gem 'drg_manual'
```
Create new Design document and put this line of code into it.

```irb
<%= dc_render :dc_manual %>
```
then create new Page document and link it to design.


You may wrap code with div element.

```irb
<%= dc_render(:dc_manual, div: 'wrap-class my-manual-class') %>
```

## Contributing
Fork this repository on GitHub and issue a pull request

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
