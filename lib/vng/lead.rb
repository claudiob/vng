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

      id = data['Client']['objectID']
      name = data['Fields'].find{|field| field['fieldID'] == 126}['fieldValue']
      email = data['Fields'].find{|field| field['fieldID'] == 238}['fieldValue']
      phone = data['Fields'].find{|field| field['fieldID'] == 1024}['fieldValue']

      new id: id, name: name, email: email, phone: phone
    end

    # Data validation failed. [{"fieldID"=>0, "fieldName"=>nil, "errNo"=>-1201, "errMsg"=>"Lead ID does not exist."}]
    # TODO: has become an account meanwhile!! so this doesn't work
    # def destroy
    #   body = {
    #     method: '4',
    #     objectID: id,
    #   }
    #
    #   self.class.request path: PATH, body: body
    # end
  end
end
