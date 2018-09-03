#!/bin/bash
#source "$HOME/.rvm/scripts/rvm"
#rvm 2.0.0
rm drg_manual*.gem
gem build drg_manual.gemspec
#gem inabox drg_books-*.gem -o -g http://gems.ozs.si
gem push drg_manual-*.gem 
