require 'vng/resource'

module Vng
  # Provides methods to interact with Vonigo leads.
  class Lead < Resource
    PATH = '/api/v1/data/Leads/'

    attr_reader :id, :name, :email, :phone

    def initialize(id:, name:, email:, phone:)
      @id = id
      @name = name
      @email = email
      @phone = phone
    end

    def self.create(name:, email:, phone:)
      body = {
        method: '3',
        Fields: [
           {fieldID: 121, optionID: '59'},
           {fieldID: 126, fieldValue: name},
           {fieldID: 238, fieldValue: email},
           {fieldID: 1024, fieldValue: phone},
        ]
      }

      data = request path: PATH, body: body

      if data['errNo']
        # 'errNo'=>-600,
        # 'errMsg'=>'Data validation failed.',
        # 'dateNow'=>'1731342482',
        # 'Errors'=>[{"fieldID"=>1024, "fieldName"=>"Phone # to Reach You", "errNo"=>-602, "errMsg"=>"Field data is in incorrect format."}]}

        # raise Vng::Error
      end

      id = data['Client']['objectID']
      name = data['Fields'].find{|field| field['fieldID'] == 126}['fieldValue']
      email = data['Fields'].find{|field| field['fieldID'] == 238}['fieldValue']
      phone = data['Fields'].find{|field| field['fieldID'] == 1024}['fieldValue']

      new id: id, name: name, email: email, phone: phone
    end

    def destroy
      body = {
        method: '4',
        objectID: id,
      }

      self.class.request path: PATH, body: body
    end
  end
end
