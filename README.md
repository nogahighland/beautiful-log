# Beautiful::Log(β)

![](https://travis-ci.org/nogahighland/beautiful-log.svg?branch=master)

Make Rails log beautiful!

## Colored log

![2016-09-28 1 24 05](https://cloud.githubusercontent.com/assets/1780339/18882983/67c4e460-851c-11e6-9600-fc100e7b7130.png)

- Thanks to [fazibear/colorize](https://github.com/fazibear/colorize) , logged messages stand out according to their levels.
- Messages align beautifully so you can start reading custom message instantly.

## Backtrace

![2016-09-28 1 20 33](https://cloud.githubusercontent.com/assets/1780339/18882985/6a8ce580-851c-11e6-9331-e1a8693e93d4.png)

Your backtrace will be neat and understandable with `Beautiful::Log::Formatter`.

- Only the file paths of **your codes** (app/..) are displayed and highlighted.
- The paths are no longer verbosely long, they are shrunk to relative path from your project root.

Rescue error, just log it `Rails.logger.error e` .

## Logs in Rake tasks

Rake tasks are fully logged with `Beautiful::Log::TaskLogging` just by adding some codes to `Rakefile` .

## Installation

**!!This gem is not published yet.!!**

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

You can change log level from `:debug` to `:fatal` depending on staging level (develop/production/test).

- Rakefile

  ```ruby
  Rails.logger = Logger.new(STDOUT)
  Rails.logger.formatter = Beautiful::Log::Formatter.new
  Rails.logger.level = Logger::DEBUG
  ```

## Configurations

You can customize displayed log by passing a hash to constructor of `Beautiful::Log::Formatter`.

```ruby
Beautiful::Log::Formatter.new(
  only_project_code: true,
  backtrace_ignore_paths: ['vendoe/bundle', /some\/path/]
)
```

Name                     | Type                     | Default             | Description
------------------------ | ------------------------ | ------------------- | -----------------------------------------------------------------------------------------------------------------
`only_project_code`      | Boolean                  | `true`              | Limit displayed file path within below the project root.
`backtrace_ignore_paths` | Array of Stringor Regexp | `['bundle/vendor']` | The ignore paths following to `Rail.root.to_s`, in case you include installed gems inside your project directory. |

### TODOs

- [ ] Color specification
- [ ] Log format specification
