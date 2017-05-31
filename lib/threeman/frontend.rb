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
  end
end
