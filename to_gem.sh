#!/bin/bash
rm drg_manual*.gem
gem build drg_manual.gemspec
gem push drg_manual-*.gem 
