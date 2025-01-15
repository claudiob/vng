module Vng
  # A mock version of HTTPRequest which returns pre-built responses.
  # @example List the species of all breeds.
  #   host = ''subdomain.vonigo.com'
  #   path = '/api/v1/resources/breeds/'
  #   body = {securityToken: security_token}
  #   response = Vng::Request.new(path: path, body: body).run
  #   response['Breeds'].map{|breed| breed['species']}
  # @api private
  class Request
    # Initializes an MockRequest object.
    # @param [Hash] options the options for the request.
    # @option options [String] :host The host of the request URI.
    # @option options [String] :path The path of the request URI.
    # @option options [Hash] :query ({}) The params to use as the query
    #   component of the request URI, for instance the Hash +{a: 1, b: 2}+
    #   corresponds to the query parameters +"a=1&b=2"+.
    # @option options [Hash] :body The body of the request.
    def initialize(options = {})
      @host = options[:host]
      @path = options[:path]
      @body = options[:body]
      @query = options.fetch :query, {}
    end

    AVAILABLE_ROUTE_ID = 1630
    @@logged_out = false

    # Sends the request and returns the body parsed from the JSON response.
    # @return [Hash] the body parsed from the JSON response.
    # @raise [Vng::ConnectionError] if the request fails.
    # @raise [Vng::Error] if parsed body includes errors.
    def run
      case @path
      when '/api/v1/security/session/'
        raise Error.new 'Same franchise ID supplied.'
      when '/api/v1/security/login/'
        if @host == 'invalid-host'
          raise ConnectionError.new 'Failed to open connection'
        else
          { "securityToken"=>"1234567" }
        end
      when '/api/v1/security/logout/'
        if @@logged_out
          raise Error.new 'Session expired. '
        else
          @@logged_out = true
          {}
        end
      when '/api/v1/resources/zips/'
        if @body[:method] == '1'
          # TODO: The response already includes the ServiceTypes so there
          # is no need to ask for those in a separate API request:
          { "Zip"=>{"zipCodeID"=>"1", "zipCode"=>"21765", "zoneName"=>"Brentwood", "defaultCity"=>"Los Angeles", "provinceAbbr"=>"CA", "franchiseID"=>"105"},
            "ServiceTypes"=>[{"serviceTypeID"=>14, "serviceType"=>"Pet Grooming", "duration" => 45}]}
        else
          { "Zips"=>[
            { "zip"=>"21763", "zoneName"=>"Brentwood", "state"=>"MD", "zipStatus"=>"Owned - Not In Service" },
            { "zip"=>"21764", "zoneName"=>"Brentwood", "state"=>"MD", "zipStatus"=>"Owned – Deactivated" },
            { "zip"=>"21765", "zoneName"=>"Brentwood", "state"=>"MD", "zipStatus"=>"Owned - Currently Serviced" },
          ] }
        end
      when '/api/v1/resources/franchises/'
        if @body.key?(:objectID)
          { "Franchise"=>{ "objectID"=>"2201007" }, "Fields"=>[
            { "fieldID"=>9, "fieldValue"=>"vng@example.com" },
            { "fieldID"=>18, "fieldValue"=>"3103103100", "optionID"=>0 },
            { "fieldID"=>1001, "fieldValue"=>"3103103100", "optionID"=>0 },
          ] }
        else
          { "Franchises"=>[
            { "franchiseID"=>106, "franchiseName"=>"Mississauga", "gmtOffsetFranchise"=>-300, "isActive"=>false },
            { "franchiseID"=>107, "franchiseName"=>"Boise", "gmtOffsetFranchise"=>-420, "isActive"=>true },
          ] }
        end
      when '/api/v1/resources/availability/'
        if @body.key?(:zip)
          { "Ids"=>{ "franchiseID"=>"172" } }
        elsif @body[:method] == '2'
          { "Ids"=>{ "lockID"=>"1406328" } }
        elsif @body[:dateStart] == 2110060800 # 11/12/2036
          { "Availability"=> [] }
        else
          { "Availability"=> [
            { "dayID"=>"20281119", "routeID"=>"#{AVAILABLE_ROUTE_ID}", "startTime"=>"1080" },
            { "dayID"=>"20281119", "routeID"=>"#{AVAILABLE_ROUTE_ID}", "startTime"=>"1110" },
          ] }
        end
      when '/api/v1/resources/breeds/'
        { "Breeds"=>[
          { "breedID"=>2, "breed"=>"Bulldog", "species"=>"Dog", "optionID"=>304, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>3, "breed"=>"Affenpinscher", "species"=>"Dog", "optionID"=>304, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>4, "breed"=>"Afghan", "species"=>"Dog", "optionID"=>304, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>5, "breed"=>"Airedale Terrier", "species"=>"Dog", "optionID"=>304, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>6, "breed"=>"Akita", "species"=>"Dog", "optionID"=>304, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>7, "breed"=>"Alaskan Malamute", "species"=>"Dog", "optionID"=>304, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>8, "breed"=>"American Eskimo", "species"=>"Dog", "optionID"=>304, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>9, "breed"=>"American Pit Bull Terrier", "species"=>"Dog", "optionID"=>304, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>10, "breed"=>"American Staffordshire Terrier", "species"=>"Dog", "optionID"=>304, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>11, "breed"=>"American Stratford Terrier", "species"=>"Dog", "optionID"=>304, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>12, "breed"=>"Anatolian Shepherd", "species"=>"Dog", "optionID"=>304, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>13, "breed"=>"Ausssiedoodle", "species"=>"Dog", "optionID"=>304, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>14, "breed"=>"Australian Shepherd", "species"=>"Dog", "optionID"=>304, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>15, "breed"=>"Australian Terrier", "species"=>"Dog", "optionID"=>304, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>16, "breed"=>"Abyssinian", "species"=>"Cat", "optionID"=>305, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>17, "breed"=>"American Bobtail", "species"=>"Cat", "optionID"=>305, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>18, "breed"=>"Bengal", "species"=>"Cat", "optionID"=>305, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>19, "breed"=>"Birman", "species"=>"Cat", "optionID"=>305, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>20, "breed"=>"Bombay", "species"=>"Cat", "optionID"=>305, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>21, "breed"=>"Burmese", "species"=>"Cat", "optionID"=>305, "breedLowWeight"=>30, "breedHighWeight"=>50 },
          { "breedID"=>22, "breed"=>"Chartreux", "species"=>"Cat", "optionID"=>305, "breedLowWeight"=>30, "breedHighWeight"=>50 },
        ] }
      when '/api/v1/data/Leads/'
        if @body[:Fields].find{|field| field[:fieldID] == 1024}[:fieldValue] == '0000000000'
          raise Error.new '[{"fieldID"=>1024, "fieldName"=>"Phone # to Reach You", "errNo"=>-602, "errMsg"=>"Field data is in incorrect format."}]'
        else
          { "Client"=>{ "objectID"=>"916347" }, "Fields"=> [
            { "fieldID"=>126, "fieldValue"=>"Vng Example" },
            { "fieldID"=>238, "fieldValue"=>"vng@example.com" },
            { "fieldID"=>1024, "fieldValue"=>"8648648640" },
            { "fieldID"=>108, "fieldValue"=>"Lead notes" },
          ] }
        end
      when '/api/v1/data/Contacts/'
        if @body[:pageNo].eql? 1
          {"Contacts" => [
            {"objectID" => "2201007", "dateLastEdited" => "1736479080", "isActive" => "true", "Fields" => [
              {"fieldID"=>127, "fieldValue"=>"Vng" },
              {"fieldID"=>128, "fieldValue"=>"Example" },
              {"fieldID"=>97, "fieldValue"=>"vng@example.com" },
              {"fieldID"=>96, "fieldValue"=>"8648648640" },
            ], "Relations" => [
              {"objectID" => 915738, "relationType" => "client", "isActive" => "true"},
            ]},
            {"objectID" => "2201008", "dateLastEdited" => "1736479081", "isActive" => "true", "Fields" => [
              {"fieldID"=>127, "fieldValue"=>"No" },
              {"fieldID"=>128, "fieldValue"=>"Email" },
              {"fieldID"=>96, "fieldValue"=>"8648648640" },
            ], "Relations" => [
              {"objectID" => 916758, "relationType" => "client", "isActive" => "true"},
            ]},
          ]}
        elsif @body[:pageNo].nil?
          { "Contact"=>{ "objectID"=>"2201007" }, "Fields"=> [
            { "fieldID"=>127, "fieldValue"=>"Vng" },
            { "fieldID"=>128, "fieldValue"=>"Example" },
            { "fieldID"=>97, "fieldValue"=>"vng@example.com" },
            { "fieldID"=>96, "fieldValue"=>"8648648640" },
          ] }
        else
          { }
        end
      when '/api/v1/data/Locations/'
        { "Location"=>{ "objectID"=>995681 } }
      when '/api/v1/data/Clients/'
        { "Client" => { "objectID" => "916758" }, "Fields" => [
          { "fieldID" => 238, "fieldValue" => "vng@example.com", "optionID" => 0 }
        ] }
      when '/api/v1/data/Assets/'
        if @body[:method].eql? '3'
          if @body[:Fields].find{|field| field[:fieldID] == 1014}[:optionID].eql? 304
            { "Asset"=>{ "objectID"=>2201008 } } # dog
          elsif @body[:Fields].find{|field| field[:fieldID] == 1014}[:optionID].eql? 305
            { "Asset"=>{ "objectID"=>2201009 } } # cat
          end
        elsif @body[:method].eql? '4'
          {}
        end
      when '/api/v1/resources/priceBlocks/'
        if @body[:pageNo].eql? 1
          { "PriceBlocks" => [
            {"priceBlockID"=>329, "priceListID"=>455, "priceBlock"=>"Affenpinscher", "sequence"=>1, "isActive"=>true},
            {"priceBlockID"=>331, "priceListID"=>455, "priceBlock"=>"Afghan", "sequence"=>2, "isActive"=>false},
            {"priceBlockID"=>332, "priceListID"=>455, "priceBlock"=>"Airedale Terrier", "sequence"=>3, "isActive"=>true},
            {"priceBlockID"=>333, "priceListID"=>455, "priceBlock"=>"Persian", "sequence"=>4, "isActive"=>true},
          ]}
        else
          { }
        end
      when '/api/v1/resources/priceLists/'
        { "PriceLists" => [
          { "priceListID" => 145, "priceList": "Pet Grooming Default", "serviceTypeID" => 14, "isActive" => true },
          { "priceListID" => 146, "priceList": "Pet Grooming Special", "serviceTypeID" => 14, "isActive" => true },
          { "priceListID" => 147, "priceList": "Pet Grooming Old", "serviceTypeID" => 14, "isActive" => false },
        ]}
      when '/api/v1/resources/priceItems/'
        if @body[:pageNo].eql? 1
          { "PriceItems"=>[
            { "priceItemID"=>275111, "priceBlockID"=>329, "descriptionHelp"=>"A price item", "sequence"=>1, "priceItem"=>"Bulldog American - 15 Step SPA Grooming Service", "value"=>85.0, "taxID"=>256, "durationPerUnit"=>45.0, "serviceBadge"=>"Required", "serviceCategory"=>"15 Step Spa", "isOnline"=>true, "isActive"=>true },
            { "priceItemID"=>275112, "priceBlockID"=>329, "descriptionHelp"=>"A price item", "sequence"=>2, "priceItem"=>"Bulldog American - 15 Step SPA Super Grooming Service", "value"=>105.0, "taxID"=>256, "durationPerUnit"=>75.0, "serviceBadge"=>nil, "serviceCategory"=>"15 Step Spa", "isOnline"=>false, "isActive"=>true },

            { "priceItemID"=>275300, "priceBlockID"=>329, "descriptionHelp"=>"A price item", "sequence"=>3, "priceItem"=>"Bulldog American - Shave Down", "value"=>40.0, "taxID"=>256, "durationPerUnit"=>30.0, "serviceBadge"=>"Not Recommended", "serviceCategory"=>"Cut", "isOnline"=>true, "isActive"=>true },
            { "priceItemID"=>275301, "priceBlockID"=>329, "descriptionHelp"=>"A price item", "sequence"=>4, "priceItem"=>"Bulldog American - Puppy Cut", "value"=>40.0, "taxID"=>256, "durationPerUnit"=>30.0, "serviceBadge"=>"Recommended", "serviceCategory"=>"Cut", "isOnline"=>true, "isActive"=>true },

            { "priceItemID"=>275302, "priceBlockID"=>331, "descriptionHelp"=>"A price item", "sequence"=>5, "priceItem"=>"De-Shedding Treatment inactive", "value"=>20.0, "taxID"=>256, "durationPerUnit"=>15.0, "serviceBadge"=>nil, "serviceCategory"=>"De-Shed", "isOnline"=>true, "isActive"=>false },
            { "priceItemID"=>275303, "priceBlockID"=>331, "descriptionHelp"=>"A price item", "sequence"=>6, "priceItem"=>"De-Shedding Treatment 0-30 lbs", "value"=>20.0, "taxID"=>256, "durationPerUnit"=>15.0, "serviceBadge"=>nil, "serviceCategory"=>"De-Shed", "isOnline"=>true, "isActive"=>true },
            { "priceItemID"=>275304, "priceBlockID"=>331, "descriptionHelp"=>"A price item", "sequence"=>7, "priceItem"=>"De-Shedding Treatment 60 - 100 lbs", "value"=>30.0, "taxID"=>256, "durationPerUnit"=>15.0, "serviceBadge"=>nil, "serviceCategory"=>"De-Shed", "isOnline"=>true, "isActive"=>true },
            { "priceItemID"=>275305, "priceBlockID"=>331, "descriptionHelp"=>"A price item", "sequence"=>8, "priceItem"=>"De-shedding Treatment - 101 lbs and over", "value"=>40.0, "taxID"=>256, "durationPerUnit"=>20.0, "serviceBadge"=>nil, "serviceCategory"=>"De-Shed", "isOnline"=>true, "isActive"=>true },

            { "priceItemID"=>275306, "priceBlockID"=>332, "descriptionHelp"=>"A price item", "sequence"=>9, "priceItem"=>"Hot Aloe SPA Re- Moisturizing Treatment 0-30 lbs", "value"=>20.0, "taxID"=>256, "durationPerUnit"=>20.0, "serviceBadge"=>nil, "serviceCategory"=>"Add Ons", "isOnline"=>true, "isActive"=>true },
            { "priceItemID"=>275307, "priceBlockID"=>332, "descriptionHelp"=>"A price item", "sequence"=>10, "priceItem"=>"Aches & Pains Package", "value"=>0.0, "taxID"=>256, "durationPerUnit"=>60.0, "serviceBadge"=>"Offered", "serviceCategory"=>"Add Ons", "isOnline"=>true, "isActive"=>true },
            { "priceItemID"=>275308, "priceBlockID"=>332, "descriptionHelp"=>"A price item", "sequence"=>11, "priceItem"=>"Old Add On", "value"=>0.0, "taxID"=>256, "durationPerUnit"=>60.0, "serviceBadge"=>"Not Offered", "serviceCategory"=>"Add Ons", "isOnline"=>true, "isActive"=>true },
          ] }
        else
          { }
        end
      when '/api/v1/data/priceLists/'
        if @body[:assetID].eql?(2201008)
          { "PriceItems"=>[
            { "priceItemID"=>275111, "priceBlockID"=>329, "descriptionHelp"=>"A price item", "sequence"=>1, "priceItem"=>"Bulldog American - 15 Step SPA Grooming Service", "value"=>85.0, "taxID"=>256, "durationPerUnit"=>45.0, "serviceBadge"=>"Required", "serviceCategory"=>"15 Step Spa", "isOnline"=>true, "isActive"=>true },
            { "priceItemID"=>275112, "priceBlockID"=>329, "descriptionHelp"=>"A price item", "sequence"=>2, "priceItem"=>"Bulldog American - 15 Step SPA Super Grooming Service", "value"=>105.0, "taxID"=>256, "durationPerUnit"=>75.0, "serviceBadge"=>nil, "serviceCategory"=>"15 Step Spa", "isOnline"=>false, "isActive"=>true },

            { "priceItemID"=>275300, "priceBlockID"=>329, "descriptionHelp"=>"A price item", "sequence"=>3, "priceItem"=>"Bulldog American - Shave Down", "value"=>40.0, "taxID"=>256, "durationPerUnit"=>30.0, "serviceBadge"=>"Not Recommended", "serviceCategory"=>"Cut", "isOnline"=>true, "isActive"=>true },
            { "priceItemID"=>275301, "priceBlockID"=>329, "descriptionHelp"=>"A price item", "sequence"=>4, "priceItem"=>"Bulldog American - Puppy Cut", "value"=>40.0, "taxID"=>256, "durationPerUnit"=>30.0, "serviceBadge"=>"Recommended", "serviceCategory"=>"Cut", "isOnline"=>true, "isActive"=>true },

            { "priceItemID"=>275302, "priceBlockID"=>331, "descriptionHelp"=>"A price item", "sequence"=>5, "priceItem"=>"De-Shedding Treatment inactive", "value"=>20.0, "taxID"=>256, "durationPerUnit"=>15.0, "serviceBadge"=>nil, "serviceCategory"=>"De-Shed", "isOnline"=>true, "isActive"=>false },
            { "priceItemID"=>275303, "priceBlockID"=>331, "descriptionHelp"=>"A price item", "sequence"=>6, "priceItem"=>"De-Shedding Treatment 0-30 lbs", "value"=>20.0, "taxID"=>256, "durationPerUnit"=>15.0, "serviceBadge"=>nil, "serviceCategory"=>"De-Shed", "isOnline"=>true, "isActive"=>true },
            { "priceItemID"=>275304, "priceBlockID"=>331, "descriptionHelp"=>"A price item", "sequence"=>7, "priceItem"=>"De-Shedding Treatment 60 - 100 lbs", "value"=>30.0, "taxID"=>256, "durationPerUnit"=>15.0, "serviceBadge"=>nil, "serviceCategory"=>"De-Shed", "isOnline"=>true, "isActive"=>true },
            { "priceItemID"=>275305, "priceBlockID"=>331, "descriptionHelp"=>"A price item", "sequence"=>8, "priceItem"=>"De-shedding Treatment - 101 lbs and over", "value"=>40.0, "taxID"=>256, "durationPerUnit"=>20.0, "serviceBadge"=>nil, "serviceCategory"=>"De-Shed", "isOnline"=>true, "isActive"=>true },

            { "priceItemID"=>275306, "priceBlockID"=>332, "descriptionHelp"=>"A price item", "sequence"=>9, "priceItem"=>"Hot Aloe SPA Re- Moisturizing Treatment 0-30 lbs", "value"=>20.0, "taxID"=>256, "durationPerUnit"=>20.0, "serviceBadge"=>nil, "serviceCategory"=>"Add Ons", "isOnline"=>true, "isActive"=>true },
            { "priceItemID"=>275307, "priceBlockID"=>332, "descriptionHelp"=>"A price item", "sequence"=>10, "priceItem"=>"Aches & Pains Package", "value"=>0.0, "taxID"=>256, "durationPerUnit"=>60.0, "serviceBadge"=>"Offered", "serviceCategory"=>"Add Ons", "isOnline"=>true, "isActive"=>true },
            { "priceItemID"=>275308, "priceBlockID"=>332, "descriptionHelp"=>"A price item", "sequence"=>11, "priceItem"=>"Old Add On", "value"=>0.0, "taxID"=>256, "durationPerUnit"=>60.0, "serviceBadge"=>"Not Offered", "serviceCategory"=>"Add Ons", "isOnline"=>true, "isActive"=>true },
          ] }
        elsif @body[:assetID].eql? 2201009
          { "PriceItems"=>[
            { "priceItemID"=>276111, "priceBlockID"=>333, "descriptionHelp"=>"A price item", "sequence"=>21, "priceItem"=>"Cat Short Hair - 15 Step SPA Grooming Service", "value"=>65.0, "taxID"=>256, "durationPerUnit"=>60.0, "serviceBadge"=>"Recommended", "serviceCategory"=>"15 Step Spa", "isOnline"=>true, "isActive"=>true },

            { "priceItemID"=>276111, "priceBlockID"=>333, "descriptionHelp"=>"A price item", "sequence"=>22, "priceItem"=>"Cat Short Hair - Lion Cut", "value"=>20.0, "taxID"=>256, "durationPerUnit"=>15.0, "serviceBadge"=>"Offered", "serviceCategory"=>"Cut", "isOnline"=>true, "isActive"=>true },
            { "priceItemID"=>276111, "priceBlockID"=>333, "descriptionHelp"=>"A price item", "sequence"=>23, "priceItem"=>"Cat Short Hair - Shave Down", "value"=>20.0, "taxID"=>256, "durationPerUnit"=>30.0, "serviceBadge"=>"Offered", "serviceCategory"=>"Cut", "isOnline"=>true, "isActive"=>true },

            { "priceItemID"=>276111, "priceBlockID"=>333, "descriptionHelp"=>"A price item", "sequence"=>24, "priceItem"=>"De-Matting - Light", "value"=>15.0, "taxID"=>256, "durationPerUnit"=>15.0, "serviceBadge"=>"Offered", "serviceCategory"=>"Add Ons", "isOnline"=>true, "isActive"=>true },
            { "priceItemID"=>276111, "priceBlockID"=>333, "descriptionHelp"=>"A price item", "sequence"=>25, "priceItem"=>"De-Matting - Moderate", "value"=>20.0, "taxID"=>256, "durationPerUnit"=>15.0, "serviceBadge"=>"Offered", "serviceCategory"=>"Add Ons", "isOnline"=>true, "isActive"=>true },
          ] }
        end
      when '/api/v1/resources/serviceTypes/'
        if @body.key?(:zip)
          {"ServiceTypes" => [
            {"serviceTypeID" => 14, "serviceType" => "Pet Grooming (name)", "duration" => 45,"isActive" => true},
            {"serviceTypeID" => 16, "serviceType" => "Pet Grooming (name)", "duration" => 45,"isActive" => false},
          ]}
        else
          { "ServiceTypes"=>[
            { "serviceTypeID"=>14, "serviceType"=>"Pet Grooming", "duration"=>90, "isActive"=>true },
          ] }
        end
      when '/api/v1/resources/Routes/'
        {"Routes" => [
          {"routeID" => AVAILABLE_ROUTE_ID, "routeName" => "Route 1", "isActive" => true},
          {"routeID" => 2, "routeName" => "Route 2", "isActive" => true},
          {"routeID" => 3, "routeName" => "Route 3 (Inactive)", "isActive" => false},
        ]}
      when '/api/v1/data/WorkOrders/'
        if @body[:pageNo].eql? 1
          {"WorkOrders" => [
            {"objectID" => "4139754", "isActive" => "true", "Fields" => [
              {"fieldID" => 185, "fieldValue" => "1736445600"},
              {"fieldID" => 813, "fieldValue" => "135.00"},
              {"fieldID" => 809, "fieldValue" => "0.00"},
              {"fieldID" => 811, "fieldValue" => "0.00"},
              {"fieldID" => 810, "fieldValue" => "0.00"},
              {"fieldID" => 186, "fieldValue" => "30"},
              {"fieldID" => 9835, "fieldValue" => "135.00"},
            ]}
          ]}
        else
          { "WorkOrder"=>{ "objectID"=>"4138030" } }
        end
      when '/api/v1/data/Cases/'
        if @body[:method].eql? '3'
          {"Case" => {"objectID" => "28503"}}
        elsif @body[:method].eql? '4'
          {}
        end
      end
    end
  end
end
