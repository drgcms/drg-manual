#!/bin/bash
#source "$HOME/.rvm/scripts/rvm"
#rvm 2.0.0
rm drg_books*.gem
gem build drg_books.gemspec
gem inabox drg_books-*.gem -o -g http://gems.ozs.si

