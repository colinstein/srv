require "webrick"
require "json"

module Srv

  class Servlet < WEBrick::HTTPServlet::AbstractServlet

    attr_reader :json_body

    METHODS = %i(get put patch post delete head options)

    METHODS.each do |method|
      define_method("do_#{method.upcase}".to_sym) do |request, response|
        set_headers(response)
        if respond_to?(method)
          set_json_body(request)
          handle_method(method, request, response)
        else
          handle_bad_method(response)
        end
      end
    end

    private

    def set_json_body(request)
      @json_body ||= begin
        JSON.parse(request.body.to_s)
      rescue JSON::ParserError
        {}
      end
    end

    def set_headers(response)
      response["Server"] = "API Server"
      response["Strict-Transport-Security"] = "max-age=#{5*60}"
      response["Content-type"] = "application/json; charset=utf-8"
    end

    def handle_method(method, request, response)
      body, code = send(method, request, response)
      response.status = code || 200
      response.body = body.to_json
    end

    def handle_bad_method(response)
      response["Allow"] = METHODS.select { |m| respond_to? m }.join(", ").upcase
      raise WEBrick::HTTPStatus::MethodNotAllowed
    end

  end

end
