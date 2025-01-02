## [2.2.1] - 2025-01-02

- Always return an array for .all methods

## [2.2.0] - 2025-01-02

- Adds Franchise#cell and Franchise#phone

## [2.1.0] - 2024-12-28

- Adds Availability.where(zip:)

## [2.0.1] - 2024-12-26

- Fix MockRequest for types

## [2.0.0] - 2024-12-26

**Breaking changes**

- Remove ServiceType.all and ServiceType.where(zip:)

## [1.7.0] - 2024-12-26

- Adds PriceItem.for_price_list_id
- Adds PriceList.all
- Adds PriceBlock.for_price_list_id

## [1.6.0] - 2024-12-24

- Adds Zip.find_by(zip:)

## [1.5.0] - 2024-12-20

- Allow Case to be created without client_id

## [1.4.4] - 2024-12-20

- Filter out ZIP codes with status 'Owned – Deactivated'
- More breeds returned by MockRequest

## [1.4.3] - 2024-12-16

- Fix MockRequest for invalid phone

## [1.4.2] - 2024-12-03

- Fix MockRequest for no availability

## [1.4.1] - 2024-11-22

- Return more routes and availabilities in MockRequest

## [1.4] - 2024-11-22

- Change Availability#route_id from string to integer

## [1.3] - 2024-11-21

- Adds MockRequest which can be set with VNG_MOCK=1

## [1.2] - 2024-11-20

- Adds WorkOrder#url and Case#url

## [1.1] - 2024-11-20

- Support optional ActiveSupport::Notifications

## [1.0.0] - 2024-11-20

- First major release
- Includes all the methods added so far
- 100% code coverage and Rubocop-happy

## [0.1.20] - 2024-11-20

- Adds Franchise.find

## [0.1.19] - 2024-11-19

- Adds Route

## [0.1.18] - 2024-11-19

- Ensure a plus sign in the email is not translated into a space

## [0.1.17] - 2024-11-17

- Require at least 30 minutes for slot

## [0.1.16] - 2024-11-17

- Require at least 30 minutes for availability

## [0.1.14] - 2024-11-17

- Adds Vng::Error

## [0.1.13] - 2024-11-15

- Enable Vng.configuration.security_token

## [0.1.12] - 2024-11-15

- Adds ServiceType.where(zip:)

## [0.1.11] - 2024-11-15

- Adds Zip

## [0.1.10] - 2024-11-14

- Adds Service Type

## [0.1.9] - 2024-11-13

- Adds Franchise

## [0.1.8] - 2024-11-13

- Adds Security Token

## [0.1.7] - 2024-11-12

- Adds Case

## [0.1.6] - 2024-11-12

- Adds WorkOrder

## [0.1.5] - 2024-11-11

- Adds Availability

## [0.1.4] - 2024-11-11

- Adds Price Item

## [0.1.3] - 2024-11-10

- Adds Location

## [0.1.2] - 2024-11-10

- Adds Breed

## [0.1.1] - 2024-11-10

- Adds Lead.create, Lead#destroy, Contact.create, Contact#destroy

## [0.1.0] - 2024-11-10

- Initial release
