require 'rubygems'
require 'uri'
require 'net/http'


class WhoisApiWrapper
  attr_reader :username, :password, :url
  
  def initialize(username=nil, password=nil)
    @username = username
    @password = password
    @url = 'http://whoisxmlapi.com/whoisserver/WhoisService?'

  end

  def request_whois(domain_name=nil)
    url = "#{@url}domainName=#{domain_name}&username=#{@username}&password=#{@password}"
    response = request_send(url)
    return response
  end


  private
    def request_send(url, limit=10)
      raise ArgumentError, 'HTTP redirect too deep.' if limit == 0
      
      response = Net::HTTP.get_response(URI.parse(url))
      
      case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then request_send(response['location'], limit - 1)
      else
        response.error!
      end
    end
end