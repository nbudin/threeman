# Threeman

Threeman is an alternative to [Foreman](https://github.com/ddollar/foreman).  Rather than running all the commands together in one terminal, it opens a tab for each command.  The benefits of this are:

* Your terminal app will notify you using an icon when there's new output from each command
* Because your command's input and output aren't being intercepted by Foreman, you can use [Pry](http://pryrepl.org)

Threeman also has an extensible architecture to allow it to support multiple terminal apps.  Right now, it supports:

* iTerm 2.9 and above
* Mac OS X's built-in Terminal app
* tmux

## Installation

Make sure you have a supported terminal app installed.

Run:

    $ gem install threeman

## Usage

From your app's directory (with a Procfile in it), run:

    $ threeman

Threeman will open a new terminal window with each of your Procfile commands running in a separate tab.

Threeman also supports reading a `.threeman` or `.foreman` file containing default options in YAML format, just like Foreman does with the `.foreman` file.  For example, a `.foreman` file containing:

```
port: 3000
```

will cause Threeman to run the app with the `PORT` environment variable set to 3000.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/patientslikeme/threeman.  Contributors are expected to follow the code of conduct specified in CODE_OF_CONDUCT.md.

## License

Threeman is &copy; 2016-2017 PatientsLikeMe, Inc. and is released under the MIT License.  See the LICENSE file for more information.

