require 'threeman/procfile'
require 'thor'
require 'yaml'

module Threeman
  FRONTENDS = {
    :iterm3 => lambda {
      require 'threeman/frontends/iterm3'
      Threeman::Frontends::Iterm3.new
    },
    :mac_terminal => lambda {
      require 'threeman/frontends/mac_terminal'
      Threeman::Frontends::MacTerminal.new
    },
    :tmux => lambda {
      require 'threeman/frontends/tmux'
      Threeman::Frontends::Tmux.new
    }
  }

  class CLI < Thor
    default_task :start

    desc "start", "Start the application"
    option :frontend, desc: "Which frontend to use.  One of: #{FRONTENDS.keys.sort.join(', ')}"
    option :port, desc: "The port to run the application on.  This will set the PORT environment variable.", type: :numeric
    def start
      pwd = Dir.pwd
      procfile = Threeman::Procfile.new(File.expand_path("Procfile", pwd))
      commands = procfile.commands(pwd, options[:port] || 5000)

      frontend_name = options[:frontend] || auto_frontend
      unless frontend_name
        puts "Couldn't determine a frontend to use.  Please specify one using --frontend."
        print_valid_frontend_names
        exit! 1
      end

      frontend(frontend_name).run_commands(commands)
    end

    private
    def frontend(name)
      frontend_lambda = FRONTENDS[name.to_sym]
      unless frontend_lambda
        puts "No frontend named #{name}!"
        print_valid_frontend_names
        exit! 1
      end

      frontend_lambda.call
    end

    def auto_frontend
      if File.exist?('/Applications/iTerm.app/Contents/Info.plist')
        iterm_version = `defaults read /Applications/iTerm.app/Contents/Info.plist CFBundleShortVersionString`
        return :iterm3 if iterm_version >= "2.9"
      end

      if File.exist?('/Applications/Utilities/Terminal.app/Contents/Info.plist')
        return :mac_terminal
      end

      `which tmux`
      if $?.success?
        return :tmux
      end
    end

    def print_valid_frontend_names
      puts "Valid frontend names are: #{FRONTENDS.keys.sort.join(', ')}."
    end

    # Cribbed mostly from Foreman
    def options
      original_options = super
      return original_options unless dotfile
      defaults = ::YAML::load_file(dotfile) || {}
      Thor::CoreExt::HashWithIndifferentAccess.new(defaults.merge(original_options))
    end

    def dotfile
      @dotfile ||= ['.threeman', '.foreman'].find { |filename| File.file?(filename) }
    end
  end
end