require "webrick"
require "webrick/https"
module Srv

  class App

    def initialize(mounts, args=ARGV)
      @config = Srv::OptionsFactory.parse(args)
      @server = WEBrick::HTTPServer.new(@config.to_h)
      mounts.each { |path, handler| @server.mount(path, handler) }
    end

    def run
      fail_with_invalid_config unless @config.valid?
      trap("INT") { @server.shutdown }
      @server.start
    end

    private

    def fail_with_invalid_config
      puts "Invalid options specified:"
      @config.errors { |option, errror| puts "#{option}: #{error.message}" }
      exit(1)
    end

  end

end
