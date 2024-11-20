require 'vng/connection_error'
require 'vng/error'

module Vng
  # Provides an abstract class for every Vonigo resource.
  class Resource
  private
    def self.request(path:, body: {}, query: {}, include_security_token: true)
      if Vng.configuration.mock
        mock_request path:, body:, query:
      else
        http_request(path:, body:, query:, include_security_token:)
      end
    end

    def self.mock_request(path:, body:, query:)
      case path
      when '/api/v1/security/login/'
        {"securityToken"=>"1234567"}
      when '/api/v1/resources/zips/'
        {"Zips"=>[{"zip"=>"21765", "zoneName"=>"Brentwood", "state"=>"MD"}]}
      when '/api/v1/resources/franchises/'
        {"Franchises"=>[
          {"franchiseID"=>106, "franchiseName"=>"Mississauga", "gmtOffsetFranchise"=>-300, "isActive"=>false},
          {"franchiseID"=>107, "franchiseName"=>"Boise", "gmtOffsetFranchise"=>-420, "isActive"=>true},
        ]}
      when '/api/v1/resources/availability/'
        if body.key?(:zip)
          {"Ids"=>{"franchiseID"=>"172"}}
        elsif body[:method] == '2'
          {"Ids"=>{"lockID"=>"1406328"}}
        else
          {"Availability"=> [
            {"dayID"=>"20241119", "routeID"=>"8949", "startTime"=>"1080"},
            {"dayID"=>"20241119", "routeID"=>"8949", "startTime"=>"1110"},
          ]}
        end
      when '/api/v1/resources/breeds/'
        {"Breeds"=>[{"breedID"=>2, "breed"=>"Bulldog", "species"=>"Dog", "optionID"=>303, "breedLowWeight"=>30, "breedHighWeight"=>50}]}
      when '/api/v1/data/Leads/'
        {"Client"=>{"objectID"=>"916347"}, "Fields"=>[
          {"fieldID"=>126, "fieldValue"=>"Vng Example"},
          {"fieldID"=>238, "fieldValue"=>"vng@example.com"},
          {"fieldID"=>1024, "fieldValue"=>"8648648640"},
        ]}
      when '/api/v1/data/Contacts/'
        {"Contact"=>{"objectID"=>"2201007"}, "Fields"=>[
          {"fieldID"=>127, "fieldValue"=>"Vng"},
          {"fieldID"=>128, "fieldValue"=>"Example"},
          {"fieldID"=>97, "fieldValue"=>"vng@example.com"},
          {"fieldID"=>96, "fieldValue"=>"8648648640"},
        ]}
      when '/api/v1/data/Locations/'
        {"Location"=>{"objectID"=>"995681"}}
      when '/api/v1/data/Assets/'
        {"Asset"=>{"objectID"=>"2201008"}}
      when '/api/v1/data/priceLists/'
        {"PriceItems"=>[
          {"priceItemID"=>275111, "priceItem"=>"15 Step SPA Grooming", "value"=>85.0, "taxID"=>256, "durationPerUnit"=>45.0, "serviceBadge"=>"Required", "serviceCategory"=>"15 Step Spa", "isOnline"=>true, "isActive"=>true},
          {"priceItemID"=>275300, "priceItem"=>"De-Shedding Treatment", "value"=>20.0, "taxID"=>256, "durationPerUnit"=>15.0, "serviceBadge"=>nil, "serviceCategory"=>"De-Shed", "isOnline"=>true, "isActive"=>false},
        ]}
      when '/api/v1/resources/serviceTypes/'
        {"ServiceTypes"=>[
          {"serviceTypeID"=>14, "serviceType"=>"Pet Grooming", "duration"=>90, "isActive"=>true},
        ]}
      when '/api/v1/data/WorkOrders/'
        {"WorkOrder"=>{"objectID"=>"4138030"}}
      when '/api/v1/data/Cases/'
        {"Case"=>{"objectID"=>"28460"}}
      else
        {}
      end
    end

    def self.http_request(path:, body:, query:, include_security_token: true)
      uri = URI::HTTPS.build host: host, path: path
      uri.query = URI.encode_www_form(query) if query.any?

      method = query.any? ? Net::HTTP::Get : Net::HTTP::Post
      request = method.new uri.request_uri
      request.initialize_http_header 'Content-Type' => 'application/json'

      if query.none?
        body = body.merge(securityToken: security_token) if include_security_token
        request.body = body.to_json
      end

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      JSON(response.body).tap do |data|
        raise Vng::Error, "#{data['errMsg']} #{data['Errors']}" unless data['errNo'].zero?
      end
    rescue Errno::ECONNREFUSED, SocketError => e
      raise Vng::ConnectionError, e.message
    end

    def self.host
      Vng.configuration.host
    end

    def self.security_token
      Vng.configuration.security_token
    end
  end
end
