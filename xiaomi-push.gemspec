# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xiaomi/push/version'

Gem::Specification.new do |spec|
  spec.name          = 'xiaomi-push'
  spec.version       = Xiaomi::Push::VERSION
  spec.authors       = ['icyleaf']
  spec.email         = ['icyleaf.cn@gmail.com']

  spec.summary       = '(unofficial) xiaomi push server sdk'
  spec.description   = '非官方小米推送服务端 Ruby SDK'
  spec.homepage      = 'http://github.com/icyleaf/xiaomi-push'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'http', '>= 2.0.0'
  spec.add_dependency 'commander', '>= 4.4.3', '< 4.6.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'

  spec.required_ruby_version = '>= 2.1.0'
end
