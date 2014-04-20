#!/bin/bash
#intended to be run from a post-receive hook that will check out master and run './install.sh'

gem uninstall tabcast --all --executables 
newgemname=$(gem build tabcast.gemspec | grep "File:" | awk '{print $2}')
gem install $newgemname
