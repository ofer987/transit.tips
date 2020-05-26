lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'seedee/version'

Gem::Specification.new do |spec|
  spec.name          = 'seedee'
  spec.version       = Seedee::VERSION
  spec.authors       = ['Dan Jakob Ofer']
  spec.email         = ['dan@ofer.to']

  spec.summary       = 'Continuous Deployment to DigitalOcean using Chef'
  spec.description   = 'Continuous Deployment to DigitalOcean using Chef for Transit.Tips'
  spec.homepage      = 'https://transit.tips'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.6'
  spec.add_development_dependency 'pry', '~> 0.11.3'
  spec.add_development_dependency 'awesome_print', '~> 1.8.0'

  spec.add_dependency 'droplet_kit', '~> 2.4.0'
  spec.add_dependency 'activesupport', '>= 5.2', '< 6.1'
  spec.add_dependency 'chef', '~> 13.6.4'
  spec.add_dependency 'chef-vault', '~> 3.4.3'
end
