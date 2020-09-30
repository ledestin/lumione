require_relative 'lib/lumione/version'

Gem::Specification.new do |spec|
  spec.name          = "lumione"
  spec.license       = "MIT"
  spec.version       = Lumione::VERSION
  spec.authors       = ["Dmitry Maksyoma"]
  spec.email         = ["ledestin@gmail.com"]

  spec.summary       = %q{to-do: Write a short summary, because RubyGems requires one.}
  spec.description   = %q{to-do: Write a longer description or delete this line.}

  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "to-do: Set to 'http://mygemserver.com'"


  spec.metadata["source_code_uri"] = "https://github.com/ledestin/lumione"
  #spec.metadata["changelog_uri"] = "to-do: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency('rdoc')
  spec.add_dependency('optparse-plus', '~> 3.0.0')
  spec.add_dependency('activesupport')
  spec.add_dependency('actionview')
  spec.add_dependency('eu_central_bank')
  spec.add_development_dependency('test-unit')
  spec.add_development_dependency('rspec', '~> 3')
end
