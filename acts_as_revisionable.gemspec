# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: acts_as_revisionable 1.2.3 ruby lib

Gem::Specification.new do |s|
  s.name = "acts_as_revisionable"
  s.version = "1.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Brian Durand"]
  s.date = "2014-10-12"
  s.description = "ActiveRecord extension that provides revision support so that history can be tracked and changes can be reverted. Emphasis for this plugin versus similar ones is including associations, saving on storage, and extensibility of the model."
  s.email = "brian@embellishedvisions.com"
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "MIT-LICENSE",
    "README.rdoc",
    "Rakefile",
    "lib/acts_as_revisionable.rb",
    "lib/acts_as_revisionable/revision_record.rb",
    "spec/acts_as_revisionable_spec.rb",
    "spec/revision_record_spec.rb",
    "spec/spec_helper.rb",
    "spec/version_1_1_upgrade_spec.rb"
  ]
  s.homepage = "http://github.com/bdurand/acts_as_revisionable"
  s.rubygems_version = "2.4.2"
  s.summary = "ActiveRecord extension that provides revision support so that history can be tracked and changes can be reverted."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.2.8"])
      s.add_runtime_dependency(%q<composite_primary_keys>, ["~> 5"])
      s.add_runtime_dependency(%q<acts_as_revisionable>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<composite_primary_keys>, ["~> 5"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 2.3.9"])
      s.add_development_dependency(%q<composite_primary_keys>, ["~> 5"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<rails>, ["~> 3.2.8"])
      s.add_dependency(%q<composite_primary_keys>, ["~> 5"])
      s.add_dependency(%q<acts_as_revisionable>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<composite_primary_keys>, ["~> 5"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 2.3.9"])
      s.add_dependency(%q<composite_primary_keys>, ["~> 5"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.2.8"])
    s.add_dependency(%q<composite_primary_keys>, ["~> 5"])
    s.add_dependency(%q<acts_as_revisionable>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.0.0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<composite_primary_keys>, ["~> 5"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.0.0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 2.3.9"])
    s.add_dependency(%q<composite_primary_keys>, ["~> 5"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.0.0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end

