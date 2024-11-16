module Vng
  # Provides methods to interact with Vonigo contacts.
  class Contact
    attr_reader :id, :first_name, :last_name, :email, :phone

    def initialize(id:, first_name:, last_name:, email:, phone:)
      @id = id
      @first_name = first_name
      @last_name = last_name
      @email = email
      @phone = phone
    end

    def self.create(first_name:, last_name:, email:, phone:, client_id:)
      body = {
        securityToken: Vng.configuration.security_token,
        method: '3',
        clientID: client_id,
        Fields: [
           {fieldID: 127, fieldValue: first_name},
           {fieldID: 128, fieldValue: last_name},
           {fieldID: 97, fieldValue: email},
           {fieldID: 96, fieldValue: phone},
        ]
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/data/Contacts/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      body = JSON response.body

      id = body['Contact']['objectID']
      first_name = body['Fields'].find{|field| field['fieldID'] == 127}['fieldValue']
      last_name = body['Fields'].find{|field| field['fieldID'] == 128}['fieldValue']
      email = body['Fields'].find{|field| field['fieldID'] == 97}['fieldValue']
      phone = body['Fields'].find{|field| field['fieldID'] == 96}['fieldValue']

      new id: id, first_name: first_name, last_name: last_name, email: email, phone: phone
    end

    def destroy
      body = {
        securityToken: Vng.configuration.security_token,
        method: '4',
        objectID: id,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/data/Contacts/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end
    end
  end
end

