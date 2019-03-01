require 'foreman/procfile'
require 'threeman/command'

module Threeman
  class Procfile < Foreman::Procfile
    def commands(workdir, port, command_prefix, formation)
      commands = []

      entries do |name, command|
        count = formation[name]
        command_with_prefix = [command_prefix, command].compact.join(' ')
        (0...count).each do |index|
          commands << Threeman::Command.new(name, command_with_prefix, workdir, port + index)
        end
      end

      commands
    end
  end
end
