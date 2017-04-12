require "openssl"

module Srv

  class Options

    DEFAULT_CIPHERS = %w(ECDHE-RSA-AES256-GCM-SHA384
                         ECDHE-ECDSA-AES256-GCM-SHA384
                         ECDHE-RSA-AES256-SHA
                         !RC4
                         !SSLv3
                         ).join(?:)

    DEFAULT_SSL_OPTIONS = OpenSSL::SSL::SSLContext.new.options |
                          OpenSSL::SSL::OP_NO_COMPRESSION

    attr_accessor :certificate_file, :key_file, :ca_certificate_file,
                  :dhparams_file, :ciphers, :port, :ssl_options

    attr_reader :errors

    def initialize(port=443)
      @port = port
      @ssl_options = DEFAULT_SSL_OPTIONS
      @errors = { ALL: "not validated" }
    end

    def valid?
      validate
      @errors.values.compact.empty?
    end

    def to_h
      {
        Port: port,
        SSLCertificate: certificate,
        SSLPrivateKey: key,
        SSLCACertificateFile: ca_certificate_file,
        SSLTmpDhCallback: proc { dhparams },
        SSLCiphers: ciphers,
        SSLCertName: [["CN",WEBrick::Utils::getservername]],
        SSLOptions: ssl_options,
        SSLEnable: true,
        SSLVerifyClient: OpenSSL::SSL::VERIFY_NONE,
      }
    end

    private

    def validate
      @errors.delete(:ALL)
      @dhparams = @key = @certificate = @ca_certificate = nil
      certificate
      key
      ca_certificate
      dhparams
      check_port_range
    end

    def check_port_range
      @errors[:port] = (0..2**16).include?(@port) ? nil : "invalid port"
    end

    def dhparams
      @dhparams ||= file_content(:dhparams, OpenSSL::PKey::DH)
    end

    def certificate
      @certificate ||= file_content(:certificate, OpenSSL::X509::Certificate)
    end

    def key
      @key ||= file_content(:key, OpenSSL::PKey::RSA)
    end

    def ca_certificate
      @ca_certificate ||= file_content(:key, String)
    end

    def file_content(error_key, reader)
      @errors.delete(error_key)
      begin
        filename = send("#{error_key}_file".to_sym)
        content = File.open(filename).read
        reader.new(content)
      rescue TypeError, Errno::ENOENT, Errno::EACCES, OpenSSL::PKey::DHError,
             OpenSSL::PKey::RSAError, OpenSSL::X509::CertificateError => e
         @errors[error_key] = e
         nil
      end
    end

  end

end
