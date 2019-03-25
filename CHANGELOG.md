# 0.9.1 - March 25, 2019

* Bug fix: add default formation of all=1 to restore previous behavior if formation isn't passed

# 0.9.0 - March 1, 2019

* Support Foreman's `--formation` (or `-m`) option

# 0.8.0 - November 29, 2018

* Add a `--command-prefix` option, which will make this easier to use in Docker Compose setups

# 0.7.0 - July 16, 2018

* Support `--procfile` and `--root` options just like Foreman does

# 0.6.0 - March 29, 2018

* Adds `--open-in-new-tab` start option to allow threeman to open tabs in existing window versus opening a new window.

# 0.5.0 - May 31, 2017

* Adds `--panes=command_name command_two` to run certain commands in panes

# 0.4.0 - March 18, 2017

* Support reading .threeman or .foreman files to get the default options

# 0.3.1 - November 13, 2016

* Fix a bug in setting the PORT environment variable (it has to be separately set before using it)

# 0.3.0 - November 11, 2016

* Support tmux!  (Thanks @sagotsky for his help.)
* Set the PORT environment variable

# 0.2.1 - March 30, 2016

* Split cd'ing into the workdir out of the bash script, so that if the process terminates you'll wind up in the right directory

# 0.2.0 - March 29, 2016

* Refactor into multiple frontends
* Add support for Mac OS X Terminal.app

# 0.1.1 - March 28, 2016

* Add license
* Add code of conduct
* Change ownership to patientslikeme

# 0.1.0 - March 28, 2016

* First release
