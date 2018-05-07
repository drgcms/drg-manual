$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "drg_manual/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "drg_manual"
  s.version     = DrgManual::VERSION
  s.authors     = ["Damjan Rems"]
  s.email       = ["drgcms@gmail.com"]
  s.homepage    = "http://www.drgcms.org"
  s.summary     = "DRG CMS: Manual plugin"
  s.description = "DRG CMS: Plugin for writing application manuals"
  s.license     = "MIT-LICENSE"
  s.metadata    = { 'source_code' => 'https://github.com/drgcms/drg-manual' }

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "drg_cms" #, "~> 0.5.0"
end
