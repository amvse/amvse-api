Amvse Ruby Client
=================

The Amvse Ruby Client is used to interact with the [Amvse API](http://docs.amvse.apiary.io/) from Ruby.

Included here is an [API Blueprint](https://apiblueprint.org/) used to generate the [API Docs](http://docs.amvse.apiary.io/) which you might be able to use to generate other API client libraries.

Usage
-----

Start by creating a connection to Amvse with your credentials:

```ruby
require 'amvse-api'
# Have an API_TOKEN?
amvse = Amvse::API.new(api_token: "SECRET_API_TOKEN")
# Don't have an API_TOKEN? 
amvse = Amvse::API.new(username: "hello@amvse.com", password: "SUP3R_SECRET_PASSWORD")
# Optional: amvse.api_token will return the new API token
```

Now you can make requests to the api.

Requests
--------

What follows is an overview of commands you can run for the client.

For additional details about any of the commands, see the [API docs](http://docs.amvse.apiary.io/).

### Websites
```ruby
amvse.get_websites                   # see a listing of all available websites
```

Mock
----

For testing (or practice) you can also use a simulated Amvse account:

```ruby
require 'amvse-api'
amvse = Amvse::API.new(api_token: "SECRET_API_TOKEN", mock: true)
```

Commands will now behave as normal, however, instead of interacting with your actual Amvse account you'll be interacting with a **blank** test account.  Note: test accounts will have NO websites to begin with. You'll need to create one:

```ruby
amvse.post_website(domain_name: 'testing.com')
```

Tests
-----

$`rspec` should do the trick.

Meta
----

Based heavily on [heroku.rb](https://github.com/heroku/heroku.rb), originally authored by geemus (Wesley Beary) and Pedro Belo. Thanks, Heroku!

Released under the [MIT license](http://www.opensource.org/licenses/mit-license.php).