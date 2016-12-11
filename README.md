# Beautiful::Log(beta)

![](https://travis-ci.org/nogahighland/beautiful-log.svg?branch=master)

Make **Rails** log beautiful!

## Colored log

![2016-09-28 1 24 05](https://cloud.githubusercontent.com/assets/1780339/18882983/67c4e460-851c-11e6-9600-fc100e7b7130.png)

- Thanks to [fazibear/colorize](https://github.com/fazibear/colorize) , logged messages stand out according to their levels.
- Messages align beautifully so you can start reading custom message instantly.

## Backtrace

<img width="709" alt="_2016-12-10_2_54_42" src="https://cloud.githubusercontent.com/assets/1780339/21059065/286b1932-be84-11e6-9d2e-5587afaf86ef.png">

Your backtrace will be neat and understandable with `Beautiful::Log::Formatter`.

- Only the file paths of **your codes** (app/..) are displayed and highlighted.
- The paths are no longer verbosely long, they are shrunk to relative path from your project root.

## Status Code

![2016-12-10 1 30 33](https://cloud.githubusercontent.com/assets/1780339/21056588/967fd198-be79-11e6-9c1e-6b44ed5cd8ae.png)

![2016-12-10 1 41 25](https://cloud.githubusercontent.com/assets/1780339/21056640/cb73fc4e-be79-11e6-88d3-0d86711d5e3b.png)

You don't miss the responses' safety any more. A log of response completion tells either your app responded correctly or not by intuitive colors. You can customize color according to status code range (hundread level e.g: `1..3`.

## Pretty-printd object

A complex object is beautifully displayed. You won't be annoyed with messy long string of object description.

- Hash

<img width="666" alt="_2016-12-12_0_53_25 2" src="https://cloud.githubusercontent.com/assets/1780339/21081243/a083793c-c005-11e6-8d7b-73308a1cc277.png">

- ActiveRecord instance

<img width="666" alt="_2016-12-12_0_53_25" src="https://cloud.githubusercontent.com/assets/1780339/21081244/a0bb1892-c005-11e6-81ef-dcf4c153400a.png">


_Rescue error, just log it `Rails.logger.error e` ._

## Logs in Rake tasks

Rake tasks are fully logged with `Beautiful::Log::TaskLogging` just by adding some codes to `Rakefile` .

## Installation

**!!This gem is not published yet.!!**

Add this line to your application's Gemfile:

```ruby
gem 'beautiful-log'
# or
gem 'beautiful-log', git: 'git@github.com:nogahighland/beautiful-log.git'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install beautiful-log
```

## Usage

- config/application.rb

  ```ruby
  config.logger = Logger.new(config.paths["log"].first)
  config.logger.formatter = Beautiful::Log::Formatter.new
  ```

- config/environments/development.rb

  ```ruby
  config.log_level = :debug # set the level you need
  ```

You can change log level from `:debug` to `:fatal` depending on staging level (develop/production/test).

- Rakefile

  ```ruby
  Rails.logger = Logger.new(STDOUT)
  Rails.logger.formatter = Beautiful::Log::Formatter.new
  Rails.logger.level = Logger::DEBUG # set the level you need
  ```

- Or just include in application.rb

  ```ruby
  module YourApplication
    class Application < Rails::Application
      # This is equivalent to code below:
      #   Rails.logger = Logger.new(config.paths['log'].first)
      #   Rails.logger.formatter = Beautiful::Log::Formatter.new
      include Beautiful::Log
      :
    end
  end
  ```

## Configurations

You can customize displayed log by passing a hash to constructor of `Beautiful::Log::Formatter`.

Below is default value.

```ruby
Beautiful::Log::Formatter.new(
  only_project_code: true,
  backtrace_ignore_paths: [],
  highlighted_line_range: 3,
  highlighted_line_styles: :cyan,
  backtrace_styles: :light_red,
  severity_styles: {}
  status_code_styles: { (1..3) => :green, 'other' => :red},
  error_file_path_styles: { FATAL: [:red, :swap], ERROR: :red, WARN: :light_red }
)
```

### Note

- `backtrace_ignore_paths` includes bundle path if you use [Bundler](http://bundler.io/). The bundle path is a string `Bundler.bundle_path` returns,  whch is written in `.bundle/config` .

- If you pass a hash as `status_code_styles` or `severity_styles`, those stypes are merged with default values shown above.

#### Style specification

- For `*_styles` keys, you can set a **Symbol** or an **Array of Symbol** to style the string (color, bold, underline, etc). The elements of the array are applied in order.

- Pick your favorite color or style (called 'mode' in [fazibear/colorize](https://github.com/fazibear/colorize/)) below.
  - [color](https://github.com/fazibear/colorize/blob/master/lib/colorize/class_methods.rb#L61)
  - [mode](https://github.com/fazibear/colorize/blob/master/lib/colorize/class_methods.rb#L78)


## Contribution

- If you find any problematic behaviors, please make an issue with problem backtrace.
- If you want to make changes, fork this repository, then make a pull request.

# TODOs

- [ ] Specs
- [ ] Publish as a gem (remoeve beta)
- [ ] Is is smarter to pass a proc/block to customize log style?

