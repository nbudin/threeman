require 'foreman/procfile'
require 'shellwords'
require 'rb-scpt'
require 'thor'

module Threeman
  class CLI < Thor
    default_task :start

    desc "start", "Start the application"
    def start
      iterm = Appscript.app("iTerm")
      iterm.activate
      window = iterm.create_window_with_default_profile

      pwd = Dir.pwd

      procfile = Foreman::Procfile.new(File.expand_path("Procfile", pwd))
      is_first = true
      procfile.entries do |name, command|
        current_tab = if is_first
          window
        else
          window.create_tab_with_default_profile
        end

        run_command(current_tab.current_session, name, pwd, command)
        is_first = false
      end
    end

    private
    def run_command(session, name, workdir, command)
      bash_script = [
        "echo -ne \"\\033]0;#{Shellwords.escape name}\\007\"",
        "cd #{workdir}",
        command
      ].join(" ; ")

      session.write(text: "bash -c #{Shellwords.escape bash_script}")
    end
  end
end