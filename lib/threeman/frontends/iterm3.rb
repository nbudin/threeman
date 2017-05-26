require 'threeman/frontend'
begin
  require 'rb-scpt'
rescue LoadError
  puts "The iterm3 frontend for Threeman requires the rb-scpt gem.  Install it using: gem install rb-scpt"
  exit!
end

module Threeman
  module Frontends
    class Iterm3 < Threeman::Frontend
      def run_commands(commands, use_panes)
        iterm = Appscript.app("iTerm")
        iterm.activate
        window = iterm.create_window_with_default_profile

        commands.each_with_index do |command, index|
          current_tab = if index == 0
            window
          elsif use_panes
            tab = window.current_session.split_horizontally_with_same_profile
            tab.select
            window
          else
            window.create_tab_with_default_profile
          end

          run_command(current_tab.current_session, command)
        end
      end

      private
      def run_command(session, command)
        cd_cmd = "cd #{Shellwords.escape command.workdir}"
        bash_cmd = "bash -c #{Shellwords.escape bash_script(command)}"
        session.write(text: [cd_cmd, bash_cmd].join("\n"))
      end
    end
  end
end
