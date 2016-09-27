# Beautiful::Log

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'beautiful-log'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install beautiful-log
```

## Usage

- config/application.rb

  ```ruby
  Logger.new(config.paths["log"].first)
  config.logger.formatter = Beautiful::Log::Formatter.new
  ```

- config/environments/development.rb

  ```ruby
  config.log_level = :debug
  ```

- Rakefile

  ```ruby
  Rails.logger = Logger.new(STDOUT)
  Rails.logger.formatter = Beautiful::Log::Formatter.new
  Rails.logger.level = Logger::DEBUG
  ```

### Configurations

To be implemented.

- Themes
- Formats
