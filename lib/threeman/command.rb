require 'shellwords'

module Threeman
  class Command
    attr_accessor :name, :command, :workdir, :port

    def initialize(name, command, workdir, port)
      @name = name
      @command = command
      @workdir = workdir
      @port = port
    end

    def bash_script
      "PORT=#{port} #{command}"
    end
  end
end