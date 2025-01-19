Vng - a Ruby client for the Vonigo API
======================================================

Vng helps you write apps that need to interact with Vonigo.

The **source code** is available on [GitHub](https://github.com/claudiob/vng) and the **documentation** on [RubyDoc](http://www.rubydoc.info/gems/vng/frames).

[![Code Climate](https://codeclimate.com/github/claudiob/vng.png)](https://codeclimate.com/github/claudiob/vng)
[![Code coverage](https://img.shields.io/badge/code_coverage-100%25-44d298)](https://github.com/claudiob/bookmaker/actions)
[![Rubygems](https://img.shields.io/gem/v/vng)](https://rubygems.org/gems/vng)

After [registering your app](#configuring-your-app), you can run commands like:


```ruby
Vng::Zip.all
Vng::Franchise.all
Vng::ServiceType.where zip:
Vng::SecurityToken.create host:, usename:, password:
Vng::Lead.create email:, phone:, name: full_name
Vng::Contact.create first_name:, last_name:, email:, phone:, client_id:
Vng::Contact.edited_since timestamp
Vng::Client.find contact_id
Vng::Location.create address:, city:, zip:, state: state, client_id:
Vng::Breed.all
Vng::Asset.create name:, weight:, breed_option_id:, client_id:
Vng::PriceItem.where location_id:, asset_id:
Vng::Availability.where location_id:, duration:, from_time:, to_time:
Vng::Lock.create date:, duration: location_id: 
Vng::WorkOrder.create lock_id:, client_id:, contact_id:, location_id:, duration:, summary:, line_items:
Vng::Case.create client_id:, summary:, comments:
```

The **full documentation** is available at [rubydoc.info](http://www.rubydoc.info/gems/vng/frames).

How to install
==============

To install on your system, run

    gem install vng

To use inside a bundled Ruby project, add this line to the Gemfile:

    gem 'vng', '~> 1.0'

Since the gem follows [Semantic Versioning](http://semver.org),
indicating the full version in your Gemfile (~> *major*.*minor*.*patch*)
guarantees that your project won’t occur in any error when you `bundle update`
and a new version of Vng is released.

Configuring your app
====================

In order to use Vng you must have credentials to the [Vonigo](https://www.vonigo.com/) API.

Add them to your code with the following snippet of code (replacing with your own credentials):

```ruby
Vng.configure do |config|
  config.host = 'subdomain.vonigo.com'
  config.username = 'VonigoUser'
  config.password = 'VonigoPassword'
end
```

Mocking the Vonigo API
======================

Sometimes you want to mock the API requests to Vonigo and obtain results that
are equivalent to the original API calls. This can be useful to test your flow
without hitting the API.


Configuring with environment variables
--------------------------------------

As an alternative to the approach above, you can configure your app with
variables. Setting the following environment variables:

```bash
export VNG_HOST="subdomain.vonigo.com"
export VNG_USERNAME="VonigoUser"
export VNG_PASSWORD="VonigoPassword"
```

is equivalent to the previous approach so pick the one you prefer.
If a variable is set in both places, then `Vng.configure` takes precedence.

How to test
===========

To run tests:

```bash
rspec
```

By default, tests are run with real HTTP calls to Vonigo that must be
set with the environment variables specified above.

If you do not have access to Vonigo, you can still run the tests mocked:

```bash
VNG_MOCK=1 rspec
```

How to release new versions
===========================

If you are a manager of this project, remember to upgrade the [Vng gem](http://rubygems.org/gems/vng)
whenever a new feature is added or a bug gets fixed.
Make sure all the tests are passing and the code is 100% test-covered.
Document the changes in CHANGELOG.md and README.md, bump the version, then run:

    rake release

Remember that the vng gem follows [Semantic Versioning](http://semver.org).
Any new release that is fully backward-compatible should bump the *minor* version (1.x).
Any new version that breaks compatibility should bump the *major* version (x.0)

How to contribute
=================

Vng needs your support!
The goal of Vng is to provide a Ruby interface for all the methods exposed by the Vonigo API.

If you find that a method is missing, fork the project, add the missing code,
write the appropriate tests, then submit a pull request, and it will gladly
be merged!
