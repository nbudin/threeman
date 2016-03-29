require 'threeman/procfile'
require 'thor'

module Threeman
  FRONTENDS = {
    :iterm3 => lambda {
      require 'threeman/frontends/iterm3'
      Threeman::Frontends::Iterm3.new
    },
    :mac_terminal => lambda {
      require 'threeman/frontends/mac_terminal'
      Threeman::Frontends::MacTerminal.new
    }
  }

  class CLI < Thor
    default_task :start

    desc "start", "Start the application"
    option :frontend
    def start
      pwd = Dir.pwd
      procfile = Threeman::Procfile.new(File.expand_path("Procfile", pwd))
      commands = procfile.commands(pwd)

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
    end

    def print_valid_frontend_names
      puts "Valid frontend names are: #{FRONTENDS.keys.sort.join(', ')}."
    end
  end
end