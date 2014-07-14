# -*- encoding: utf-8 -*-
# stub: radiustar 0.0.8 ruby lib

Gem::Specification.new do |s|
  s.name = "radiustar"
  s.version = "0.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["PJ Davis"]
  s.date = "2012-07-23"
  s.description = "Ruby Radius Library"
  s.email = "pj.davis@gmail.com"
  s.extra_rdoc_files = ["History.txt", "README.rdoc", "templates/default.txt"]
  s.files = ["History.txt", "README.rdoc", "templates/default.txt"]
  s.homepage = "http://github.com/pjdavis/radiustar"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.rubyforge_project = "radiustar"
  s.rubygems_version = "2.2.2"
  s.summary = "."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ipaddr_extensions>, ["~> 1.0.0"])
      s.add_development_dependency(%q<bones>, [">= 3.7.3"])
    else
      s.add_dependency(%q<ipaddr_extensions>, ["~> 1.0.0"])
      s.add_dependency(%q<bones>, [">= 3.7.3"])
    end
  else
    s.add_dependency(%q<ipaddr_extensions>, ["~> 1.0.0"])
    s.add_dependency(%q<bones>, [">= 3.7.3"])
  end
end
