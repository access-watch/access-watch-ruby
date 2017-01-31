# Access Watch Ruby library

A Ruby library to log and analyse HTTP requests using the [Access Watch](http://access.watch/) cloud service.

## Installation

Install the latest version with

```gem install access_watch```

or in your Gemfile

```gem "access_watch"```

## Basic Usage

You will need an API key.

To get an API key, send us an email at api@access.watch and we will come back to you.

```ruby

client = AccessWacth::Client.new(api_key: YOUR_API_KEY)
client.post("log", REQUEST_DATA_IN_JSON)
```

API documentation is here: https://access.watch/api-documentation/#request-logging

### Author

Alexis Bernard - <alexis@bernard.io> - <http://basesecrete.com/>

### License

The Access Watch Ruby library is licensed under the MIT License - see the `LICENSE` file for details
