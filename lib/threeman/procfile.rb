require 'foreman/procfile'
require 'threeman/command'

module Threeman
  class Procfile < Foreman::Procfile
    def commands(workdir, port)
      commands = []

      entries do |name, command|
        commands << Threeman::Command.new(name, command, workdir, port)
      end

      commands
    end
  end
end