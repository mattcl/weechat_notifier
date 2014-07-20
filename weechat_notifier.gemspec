# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weechat_notifier/version'

Gem::Specification.new do |spec|
  spec.name          = 'weechat_notifier'
  spec.version       = WeechatNotifier::VERSION
  spec.authors       = ['Matt Chun-Lum']
  spec.email         = ['mchunlum@gmail.com']
  spec.summary       = %q{Triggers notifications from a remote weechat box}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'bunny'
  spec.add_dependency 'libnotify'
  spec.add_dependency 'thor'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
