require 'threeman/frontend'

module Threeman
  module Frontends
    class Tmux < Threeman::Frontend
      attr_reader :session

      def initialize(options)
        @session = "threeman_#{Time.now.to_i}"
        super
      end

      def run_commands(commands)
        sort_commands(commands).each_with_index do |command, index|
          run_command(command, index)
        end

        system "tmux attach-session -t #{session}"
      end

      private
      def run_command(command, index)
        bash_cmd = "bash -c #{Shellwords.escape bash_script(command)}"

        name_opt = "-n #{Shellwords.escape command.name}"
        common_opts = "-c #{Shellwords.escape command.workdir} #{Shellwords.escape bash_cmd}"
        if index == 0
          system "tmux new-session -d -s #{session} #{name_opt} #{common_opts}"
        elsif paned_command_names.include?(command.name)
          system "tmux split-window -v -d -f -t #{session}:0.#{index - 1} #{common_opts}"
          system "tmux select-layout -t #{session}:0 #{layout_name}"
        else
          system "tmux -v new-window -t #{session}:#{index} #{name_opt} #{common_opts}"
        end
      end

      def layout_name
        options[:layout_name] || 'tiled'
      end
    end
  end
end
