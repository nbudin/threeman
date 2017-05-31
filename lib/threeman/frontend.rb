require 'shellwords'

module Threeman
  class Frontend
    attr_reader :options

    def initialize(options)
      @options = options
    end

    def run_commands(commands)
      raise "Subclasses must implement #run_commands"
    end

    def bash_script(command)
      [
        "echo -ne \"\\033]0;#{Shellwords.escape command.name}\\007\"",
        command.bash_script
      ].join(" ; ")
    end

    def sort_commands(commands)
      commands.sort_by { |c| paned_command_names.include?(c.name) ? 0 : 1 }
    end

    def paned_command_names
      options[:panes] || []
    end
  end
end
