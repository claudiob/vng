module Vng
  # Provides methods to interact with Vonigo leads.
  class Lead
    attr_reader :id, :name, :email, :phone

    def initialize(id:, name:, email:, phone:)
      @id = id
      @name = name
      @email = email
      @phone = phone
    end

    def self.create(name:, email:, phone:)
      body = {
        securityToken: Vng.configuration.security_token,
        method: '3',
        Fields: [
           {fieldID: 121, optionID: '59'},
           {fieldID: 126, fieldValue: name},
           {fieldID: 238, fieldValue: email},
           {fieldID: 1024, fieldValue: phone},
        ]
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/data/Leads/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      body = JSON response.body

      if body['errNo']
        # 'errNo'=>-600,
        # 'errMsg'=>'Data validation failed.',
        # 'dateNow'=>'1731342482',
        # 'Errors'=>[{"fieldID"=>1024, "fieldName"=>"Phone # to Reach You", "errNo"=>-602, "errMsg"=>"Field data is in incorrect format."}]}

        # raise Vng::Error
      end

      id = body['Client']['objectID']
      name = body['Fields'].find{|field| field['fieldID'] == 126}['fieldValue']
      email = body['Fields'].find{|field| field['fieldID'] == 238}['fieldValue']
      phone = body['Fields'].find{|field| field['fieldID'] == 1024}['fieldValue']

      new id: id, name: name, email: email, phone: phone
    end

    def destroy
      body = {
        securityToken: Vng.configuration.security_token,
        method: '4',
        objectID: id,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/data/Leads/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end
    end
  end
end
