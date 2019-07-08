
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "specterr/version"

Gem::Specification.new do |spec|
  spec.name          = "specterr"
  spec.version       = Specterr::VERSION
  spec.authors       = ["Gaurav Singh, Kapil Bhoale, Akshay Mohite"]
  spec.email         = ["gaurav.singh@coupa.com, kapil@dtreelabs.com, akshay@dtreelabs.com"]

  spec.summary       = "Test"
  spec.description   = "Test"
  spec.homepage      = "http://specterr.dtreelabs.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = 'http://mygemserver.com'
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'sucker_punch', '~> 2.0'
  spec.add_dependency 'sqlite3', '~> 1.3', '>= 1.3.11'
  spec.add_dependency 'pg'
  spec.add_dependency 'rack'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
