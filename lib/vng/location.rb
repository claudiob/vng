module Vng
  # Provides methods to interact with Vonigo locations.
  class Location
    # TODO: fetch from /system/objects/ method: 1, objectID: 20
    STATES_OPTION_ID = {
      AK: 9879, AL: 9878, AR: 9877, AZ: 9880, CA: 9883, CO: 9876, CT: 9875,
      DC: 9874, DE: 9873, FL: 9872, GA: 9871, HI: 9870, IA: 9869, ID: 9868,
      IL: 9867, IN: 9866, KS: 9865, KY: 9864, LA: 9863, MA: 9862, MD: 9861,
      ME: 9860, MI: 9859, MN: 9858, MO: 9857, MS: 9856, MT: 9855, NC: 9854,
      ND: 9853, NE: 9852, NH: 9851, NJ: 9850, NM: 9849, NV: 9829, NY: 9848,
      OH: 9847, OK: 9846, OR: 9881, PA: 9845, RI: 9843, SC: 9841, SD: 9842,
      TN: 9840, TX: 9839, UT: 9838, VA: 9837, VT: 9836, WA: 9882, WI: 9828,
      WV: 9835, WY: 9834,
    }

    attr_reader :id

    def initialize(id:)
      @id = id
    end

    def self.create(address:, city:, zip:, state:, client_id:)
      body = {
        securityToken: Vng.configuration.security_token,
        method: "3",
        clientID: client_id,
        Fields: [
           {fieldID: 779, optionID: 9906}, # "USA"
           {fieldID: 778, optionID: STATES_OPTION_ID[state.to_sym]},
           {fieldID: 776, fieldValue: city},
           {fieldID: 773, fieldValue: address},
           {fieldID: 775, fieldValue: zip},
        ]
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/data/Locations/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end

      new id: JSON(response.body)["Location"]["objectID"]
    end

    def destroy
      body = {
        securityToken: Vng.configuration.security_token,
        method: "4",
        objectID: id,
      }

      uri = URI::HTTPS.build host: 'aussiepetmobileusatraining2.vonigo.com', path: '/api/v1/data/Locations/'

      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header 'Content-Type' => 'application/json'
      request.body = body.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request request
      end
    end
  end
end

