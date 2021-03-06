require 'threeman/procfile'
require 'thor'
require 'yaml'

module Threeman
  FRONTENDS = {
    :iterm3 => lambda { |options|
      require 'threeman/frontends/iterm3'
      Threeman::Frontends::Iterm3.new(options)
    },
    :mac_terminal => lambda { |options|
      require 'threeman/frontends/mac_terminal'
      Threeman::Frontends::MacTerminal.new(options)
    },
    :tmux => lambda { |options|
      require 'threeman/frontends/tmux'
      Threeman::Frontends::Tmux.new(options)
    }
  }

  class CLI < Thor
    default_task :start

    desc "start", "Start the application"
    option :frontend, desc: "Which frontend to use.  One of: #{FRONTENDS.keys.sort.join(', ')}"
    option :layout_name, desc: "If using tmux, the layout name to use for paned commands", type: :string
    option :procfile, desc: "Procfile file name", default: "Procfile", aliases: "-f"
    option :root, desc: "Directory of Procfile", aliases: "-d"
    option :formation, aliases: '-m'
    option(
      :open_in_new_tab,
      desc: "If using iterm3, configure how threeman opens",
      type: :boolean
    )
    option(
      :panes,
      desc: "Runs each command in a pane, if supported by the frontend.  (Currently supported in iterm3 and tmux.)",
      type: :array
    )
    option(
      :port,
      desc: "The port to run the application on.  This will set the PORT environment variable.",
      type: :numeric
    )
    option(
      :command_prefix,
      desc: "If specified, prefix each command in Procfile with this string",
      type: :string
    )

    def start
      procfile_name = options[:procfile]
      pwd = options[:root] || Dir.pwd
      procfile = Threeman::Procfile.new(File.expand_path(procfile_name, pwd))
      formation = parse_formation(options[:formation] || 'all=1')
      commands = procfile.commands(pwd, options[:port] || 5000, options[:command_prefix], formation)

      frontend_name = options[:frontend] || auto_frontend
      unless frontend_name
        puts "Couldn't determine a frontend to use.  Please specify one using --frontend."
        print_valid_frontend_names
        exit! 1
      end

      valid_frontend_open_option?(frontend_name) if options[:open_in_new_tab]

      frontend(frontend_name, options).run_commands(commands)
    end

    private
    def valid_frontend_open_option?(frontend_name)
      unless frontend_name == :iterm3
        puts "Opening in a new tab is only supported for iterm3"
        exit! 1
      end
    end

    def frontend(name, options = {})
      frontend_lambda = FRONTENDS[name.to_sym]
      unless frontend_lambda
        puts "No frontend named #{name}!"
        print_valid_frontend_names
        exit! 1
      end

      frontend_lambda.call(options)
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

    def parse_formation(formation)
      pairs = formation.to_s.gsub(/\s/, "").split(",")

      pairs.inject(Hash.new(0)) do |ax, pair|
        process, amount = pair.split("=")
        process == "all" ? ax.default = amount.to_i : ax[process] = amount.to_i
        ax
      end
    end
  end
end
