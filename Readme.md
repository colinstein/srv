# SRV 0.0.1
A simple HTTP server using the ruby standandard library. It's intended to
quickly get a HTTP server with strong TLS configuration up and running quickly,
sticking with the Ruby standard library.

You'll probably never want to use this in production, but I have found it useful
as a way to bootstrap a web call-back or slap a simple interface around a shell
script temporarily.

## Requirements
  * Ruby 2.4.0, you can monkey-patch in the `SSLCiphers` options into
    `Webrick::Config` if you'd like it to work with earlier versions.

  * An SSL certificate, Key, DHParams file, and Certificate Authority's
    certificates. Let's Encrypt is a great place to start if you own the
    domain that you'll be listening on, otherwise you'll use self-signed
    ones and deal with the complexity. If you're buying EV certificates
    then you probably should have moved to something better. At least
    Rack+Puma, maybe another language entirely.

## Getting started
Assuming a typical Ruby/Bundler install:

  1. Create a Gemfile:

    $ touch Gemfile

  2. Edit `Gemfile` so that it loads the srv gem:

    gem "srv", "0.0.1"

  3. Install the gem using Bundler

    $ bundle install

  3. Create your "server" application:

    $ touch server.rb
    $ chmod +x server.rb

  4. Write a simple servlet

     #!/usr/bin/ruby -w
     require "srv"

     class Home < Srv::Servlet
       def get request, response
         { uptime: `uptime` }
       end
     end

     Srv::App.new("/": Home).run

  5. Start the application

     $ bundle exec ./server.rb \
       -d dhparam.pem \
       -c example.com.crt \
       -k example.com.key \
       -a example.com.issuer.crt \
       -p 8443

The intention is that you're always dealing with JSON as an API so there are
a couple of minor quirks:

  * If you return a single object then it'll be sent back as the body of
    the response after having `.to_json` called on it.

  * If you return two objects then the second one will be the http status.

  * You can bail out of a request and display an error message by raising
    a standard exception:

    `raise  raise HTTPStatus::Forbidden, "You cannot do that."`

## Notes
Mostly this was just an experiment to see what it would take to get an A+
rating on Qualys SSL Server Test, it just happened to scratch an itch I had
at work one day too.

### Todo
  * It'd be nice to have defaults for the command line options, and then let
    them be overriden by environment variables, which in turn are over-written
    by a config file. Something like a config.ru

  * Tests. Nobody likes writing them, but I should do it.

  * Additional configuration options (HSTS) just to make it less painful to
    test things.

  * Better handling of HTTP errors. It'd be nice to make it all pure json

  * A "bin" in the gem so you can just run `srv somefile.rb` to bring it up

  * Maybe a handful of helper functions? Authenticate an HMAC, some sort of
    "prepend" magic to automatically decode bodies into JSON? Maybe a data-store
    using YML? Static path serving? I hesistate to add too much because that
    gets us beyond what we wanted for a minimal test gem.

  * Better logging

  * Documentation and examples

  * Continuous integration and a nice github page.

  * A GUI wrapper for macOS. Sometimes I just want a super-light-weight API mock
    that I can use when I'm developing something else. I suspect more people
    would do the same if there was a way to control it all from the menu extras.

  * Windows/Linux stuff too? How hard can it be?
