# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "tabcast"
  spec.version       = `cat GEM_VERSION`
  spec.authors       = ["Cameron Tindall"]
  spec.email         = ["ctindall@gmail.com"]
  spec.summary       = "A small command to help munge podcast feeds in shell scripts."
  spec.description   = "tabcast is a command that will take a podcast feed and format it's data in a more shell-friendly format, by default into a tab-delimited list. It's powered by the Liquid templating enging to make it very flexible."
  spec.homepage      = 'http://github.com/ctindall/tabcast'
  spec.license       = ""

  spec.bindir        = 'bin'

  spec.files 	     = [ 'bin/tabcast', 'lib/tabcast.rb' ]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
