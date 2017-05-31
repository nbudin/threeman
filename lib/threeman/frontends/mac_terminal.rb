require 'threeman/frontend'
begin
  require 'rb-scpt'
rescue LoadError
  puts "The mac_terminal frontend for Threeman requires the rb-scpt gem.  Install it using: gem install rb-scpt"
  exit!
end

module Threeman
  module Frontends
    class MacTerminal < Threeman::Frontend
      def run_commands(commands)
        events = Appscript.app("System Events")

        terminal = Appscript.app("Terminal")
        terminal.activate

        terminal_controller = events.processes['Terminal']

        commands.each_with_index do |command, index|
          if index == 0
            terminal.do_script("")
          else
            sleep 0.3 # Terminal is slow and its scripting API is prone to misbehavior; wait for it to finish doing the thing we just did

            terminal_controller.keystroke("t", using: [:command_down])
            terminal.do_script("", in: terminal.windows[0])
          end

          sleep 0.3
          terminal_controller.keystroke("cd #{Shellwords.escape command.workdir}\n")
          terminal_controller.keystroke(bash_cmd(command) + "\n")
        end
      end

      private
      def bash_cmd(command)
        "bash -c #{Shellwords.escape bash_script(command)}"
      end
    end
  end
end
