# Threeman

Threeman is an alternative to [Foreman](https://github.com/ddollar/foreman) for Mac users.  Rather than running all the commands together in one terminal, it opens a new [iTerm 2](https://www.iterm2.com) window with each command in a tab.  The benefits of this are:

* iTerm 2 will notify you using an icon when there's new output from each command
* Because your command's input and output aren't being intercepted by Foreman, you can use [Pry](http://pryrepl.org)

## Installation

Make sure you have [iTerm 2](https://www.iterm2.com/downloads.html) at least version 2.9 installed.

Run:

    $ gem install threeman

## Usage

From your app's directory (with a Procfile in it), run:

    $ threeman

Threeman will open a new iTerm 2 window with each of your Procfile commands running in a separate tab.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nbudin/threeman.

