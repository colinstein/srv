require "optparse"

module Srv

  class OptionsFactory

    def self.parse(args)
      options = Options.new
      options.ciphers = Options::DEFAULT_CIPHERS

      parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{__FILE__} [options]"
        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-p", "--port N", OptionParser::DecimalInteger, "TCP Port to listen on.") do |port|
          options.port = port
        end

        opts.on("-c", "--certificate FILE", "SSL certificate file") do |file|
          options.certificate_file = file
        end

        opts.on("-k", "--key FILE", "SSL key file") do |file|
          options.key_file = file
        end

        opts.on("-d", "--dhparams FILE", "DHParams file") do |file|
          options.dhparams_file = file
        end

        opts.on("-a", "--ca-certificate FILE", "CA certifacte file") do |file|
          options.ca_certificate_file = file
        end

        opts.on("-C", "--ciphers CIPHERS", "Enabled ciphers, ':' separated list.") do |ciphers|
          options.ciphers = ciphers
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

      end

      parser.parse!(args)
      options

    end

  end
end
