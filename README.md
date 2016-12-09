# Beautiful::Log(β)

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

Below is default value.

```ruby
Beautiful::Log::Formatter.new(
  only_project_code: true,
  backtrace_ignore_paths: [],
  highlighted_line_range: 3,
  highlighted_line_color: :cyan,
  backtrace_color: :light_red,
  error_file_path_color: :red,
  status_code_color: { (1..3) => :green, 'other' => :red}
)
```

### Note

- `backtrace_ignore_paths` includes bundle path if you use [Bundler](http://bundler.io/). The bundle path is a string `Bundler.bundle_path` returns, or the path whch is written in `.bundle/config` .

- Pick your favorite color from [fazibear/colorize](https://github.com/fazibear/colorize/blob/master/lib/colorize/class_methods.rb#L61).

- If you pass a hash as `status_code_color`, status colors are merged with default values shown above.

## Contribution

- If you find any problematic behaviors, please make an issue with problem backtrace.
- If you want to make changes, fork this repository, then make a pull request.

# TODOs

- [ ] Is is smarter to call a method with a block when customize log style?
- [ ] Customize log _header_ style according to its severity
- [ ] Specs

