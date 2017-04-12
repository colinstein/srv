$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'srv/version'

Gem::Specification.new do |s|
  s.name        = "srv".freeze
  s.version     = Srv::VERSION
  s.date        = "2017-02-11".freeze
  s.summary     = "TLS Server / HTTP micro framwork".freeze
  s.description = <<-DESCRIPTION
Srv is a trival mini-framework/HTTP server. It expects a few simple 'servelets'
to be written and will expose them on an HTTP server configured with a strong
TLS connection. The expected use case is quickly / temporarily exposing some
minor shell script behind a basic API that sends/recieves JSON. I hestitate to
call it a framework because it's not intended to last more than a few hours or
support any significant traffic. Srv has the following features
  * Presents a strong TLS configuration by default
  * Easily mount servlets with trivial routing
  * passably-nice command line interface
It pairs nicely with certificates generated by Lets Encrypt.
DESCRIPTION
  s.license     = "MIT".freeze

  s.author      = "Colin Stein".freeze
  s.email       = "colinstein@mac.com".freeze
  s.homepage    = "https://github.com/colinstein/srv.git".freeze

  s.files       = ["lib/srv.rb",
                   "lib/srv/options.rb",
                   "lib/srv/options_factory.rb",
                   "lib/srv/servlet.rb",
                   "lib/srv/version.rb",
                   "lib/srv/app.rb",
                  ]

  s.platform               = Gem::Platform::RUBY
  s.required_ruby_version  = ">= 2.4.0".freeze
  s.require_paths          = ["lib".freeze]

  s.add_development_dependency("bundler".freeze, "~>1.14".freeze)
end
