require 'threeman/frontend'

module Threeman
  module Frontends
    class Tmux < Threeman::Frontend
      attr_reader :session

      def initialize
        @session = "threeman_#{Time.now.to_i}"
      end

      def run_commands(commands)
        commands.each_with_index do |command, index|
          run_command(command, index)
        end

        system "tmux attach-session -t #{session}"
      end

      private
      def run_command(command, index)
        bash_cmd = "bash -c #{Shellwords.escape bash_script(command)}"
        if index == 0
          system "tmux new-session -d -s #{session} -c #{Shellwords.escape command.workdir} #{Shellwords.escape bash_cmd}"
        else
          system "tmux -v new-window -t #{session}:#{index} -c #{Shellwords.escape command.workdir} #{Shellwords.escape bash_cmd}"
        end
      end
    end
  end
end