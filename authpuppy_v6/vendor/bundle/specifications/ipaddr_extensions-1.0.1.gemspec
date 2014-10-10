# -*- encoding: utf-8 -*-
# stub: ipaddr_extensions 1.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "ipaddr_extensions"
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["James Harton"]
  s.date = "2013-12-19"
  s.email = "james@resistor.io"
  s.homepage = "http://github.com/jamesotron/IPAddrExtensions"
  s.rubygems_version = "2.2.2"
  s.summary = "A small gem that adds extra functionality to Rubys IPAddr class"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
