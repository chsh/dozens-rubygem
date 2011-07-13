require "dozens/version"

require 'net/http'
require 'uri'
require 'json'

module Dozens
  class API
    API_BASE = 'http://dozens.jp/api/'
    ZONE_BASE = API_BASE + 'zone'
    RECORD_BASE = API_BASE + 'record'

    def initialize(dozens_id, api_key)
      @dozens_id = dozens_id
      @api_key = api_key
    end
    def authenticate
      auth_token
    end
    def zones
      get_with_auth ZONE_BASE + '.json'
    end
    def create_zone(params)
      post_with_auth ZONE_BASE + '/create.json', params
    end
    def delete_zone(zone_id)
      delete_with_auth ZONE_BASE + "/delete/#{zone_id}.json"
    end
    def records(zone_name)
      get_with_auth RECORD_BASE + "/#{zone_name}.json"
    end
    def create_record(params)
      post_with_auth RECORD_BASE + "/create.json", params
    end
    def update_record(record_id, params)
      post_with_auth RECORD_BASE + "/update/#{record_id}.json", params
    end
    def delete_record(record_id)
      delete_with_auth RECORD_BASE + "/delete/#{record_id}.json"
    end

    private
    def get_with_headers(url, headers = {})
      request :get, url, headers
    end
    def get_with_auth(url)
      with_auth do |hdrs|
        request :get, url, hdrs
      end
    end
    def post_with_auth(url, params)
      with_auth do |hdrs|
        request :post, url, hdrs, params
      end
    end
    def put_with_auth(url)
      with_auth do |hdrs|
        request :put, url, hdrs
      end
    end
    def delete_with_auth(url)
      with_auth do |hdrs|
        request :delete, url, hdrs
      end
    end
    def request(verb, url, headers = {}, params = {})
      uri = URI.parse(url)
      klass = eval "Net::HTTP::#{verb.capitalize}"
      req = klass.new(uri.path)
      headers.each do |key, value|
        req[key] = value
      end
      if req.request_body_permitted? && !params.empty?
        req.body = params.to_json.to_s
        req['Content-Type'] = 'application/json'
      end
      resp = nil
      Net::HTTP.start(uri.host, uri.port) do |http|
        resp = http.request(req)
      end
      JSON.parse(resp.body)
    end
    def with_auth(org_headers = {}, &block)
      block.call(org_headers.merge({'X-Auth-Token' => auth_token}))
    end
    def authorize_get(dozens_id, api_key)
      resp = get_with_headers('http://dozens.jp/api/authorize.json',
                              'X-Auth-User' => @dozens_id,
                              'X-Auth-Key' => @api_key)
      resp['auth_token']
    end
    def auth_token
      @auth_token ||= authorize_get(@dozens_id, @api_key)
    end
  end
end
