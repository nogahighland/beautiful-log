# Beautiful::Log(beta)

![](https://travis-ci.org/nogahighland/beautiful-log.svg?branch=master)
[![Gem Version](https://badge.fury.io/rb/beautiful-log.svg)](https://badge.fury.io/rb/beautiful-log)

Make **Rails** log beautiful!

## Colored log

![2016-09-28 1 24 05](https://cloud.githubusercontent.com/assets/1780339/18882983/67c4e460-851c-11e6-9600-fc100e7b7130.png)

- Thanks to [fazibear/colorize](https://github.com/fazibear/colorize), logged messages stand out according to their levels.
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

Thanks to [awesome-print/awesome_print](https://github.com/awesome-print/awesome_print), a complex object is beautifully displayed. You won't be annoyed with messy long string of object description.

- Hash

<img width="691" alt="hash" src="https://cloud.githubusercontent.com/assets/1780339/21100292/a3fec7cc-c0b6-11e6-9800-d711e8b9e829.png">

- ActiveRecord instance

<img width="691" alt="ar" src="https://cloud.githubusercontent.com/assets/1780339/21100291/a3fea602-c0b6-11e6-9ab3-d7bca6455947.png">

[awesome-print/awesome_print](https://github.com/awesome-print/awesome_print) supports [more types](https://github.com/awesome-print/awesome_print/tree/master/lib/awesome_print/formatters) to beautiflize.

_All you need to do is rescue error, just log it `Rails.logger.error e` ._

## Logs in Rake tasks

Rake tasks are fully logged with `Beautiful::Log::TaskLogging` just by adding some codes to `Rakefile` .

## Installation

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

You can change the log level from `:debug` to `:fatal` depending on staging level (develop/production/test).

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

You can customize the log appearance by passing a hash to constructor of `Beautiful::Log::Formatter`.

Below is a hash containing default values.

```ruby
Beautiful::Log::Formatter.new(
  only_project_code: true,
  shrink_bundle_path: true,
  backtrace_ignore_paths: [],
  highlighted_line_range: 3,
  highlighted_line_styles: :cyan,
  backtrace_styles: :light_red,
  error_file_path_styles: :red,
  severity_styles: { FATAL: [:red, :swap], ERROR: :red, WARN: :light_red },
  status_code_styles: { (1..3) => [:green, :bold], 'other' => [:red, :bold] },
  occurence_line: :light_blue
)
```

### Note

- `backtrace_ignore_paths` includes bundle path if you use [Bundler](http://bundler.io/). The bundle path is a string `Bundler.bundle_path` returns,  which is written in `.bundle/config` .

- If you pass a hash as `status_code_styles` or `severity_styles`, those styles are merged with default values shown above.

#### Style specification

- For `*_styles` keys, you can set a **Symbol** or an **Array of Symbol** to style a string (color, bold, underline, etc). The elements of the array are applied in order.

- Pick your favorite color or style (called 'mode' in [fazibear/colorize](https://github.com/fazibear/colorize/)) below.
  - [color](https://github.com/fazibear/colorize/blob/master/lib/colorize/class_methods.rb#L61)
  - [mode](https://github.com/fazibear/colorize/blob/master/lib/colorize/class_methods.rb#L78)


## Requirements

- Ruby 2.3-

## Contribution

- If you find any problematic behaviors, please make an issue with problem backtrace.
- If you want to make changes, fork this repository, then make a pull request.

# TODOs

- [ ] Specs
- [ ] Is is smarter to pass a proc/block to customize log style?

