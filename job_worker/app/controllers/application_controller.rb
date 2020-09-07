require 'byebug'
class ApplicationController < ActionController::API
  #This will require the verification of a client certificate against the server's private key
  # otherwise API endpoint will not be reached
  before_action :require_authentication

    private

    #returns true if the certificate being passed with the cli http request can be verified with the server's private key
    def require_authentication
      unless current_certificate.verify(private)
        head :forbidden
      end
    end

    #Returns the private master key for the server that signed the client certificate
    def private
      @private ||= OpenSSL::PKey::RSA.new(File.read("server_key.pem"))
    end

    #the client's certificate passed via http request
    def current_certificate
      @current_certificate ||= OpenSSL::X509::Certificate.new(File.read(params[:client]))
    end

    def current_client
      current_certificate.issuer.to_a.assoc('OU')[1]
    end

end
