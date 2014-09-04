# Polymer Google Apis Web Component Gem

This is [Google APIs web component](https://github.com/GoogleWebComponents/google-apis) packed as a Gem.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'polymer-google-apis'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install polymer-google-apis

## Getting started


```ruby
gem 'polymer-rails'
gem 'polymer-google-apis
```

After runnign `bundle install` require needed paper elements into your `application.html` manifest file. This adds all APIs

    //= require polymer/polymer
    //= require google-apis/google-apis

You can add them separately. 

    //= require google-apis/google-client-api
    
    //= require google-apis/google-jsapi
    
    //= require google-apis/google-maps-api
    
    //= require google-apis/google-plusone-api
    
    //= require google-apis/google-youtube-api


Each component should be required only once. Thus if you've already required component that has dependencies, you don't need to explicitly require any of dependencies, otherwise it will raise exception.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
