require 'foreman/procfile'
require 'threeman/command'

module Threeman
  class Procfile < Foreman::Procfile
    def commands(workdir, port, command_prefix)
      commands = []

      entries do |name, command|
        command_with_prefix = [command_prefix, command].compact.join(' ')
        commands << Threeman::Command.new(name, command_with_prefix, workdir, port)
      end

      commands
    end
  end
end
