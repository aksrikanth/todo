namespace :srv do
  pid_file = "tmp/pids/unicorn.pid"

  desc "start the HTTP server"
  task :start do
    unless process_running(pid_file)
      sh %{bundle exec unicorn --eval '"todo"' --config config/unicorn.rb --daemonize}
    end
  end

  desc "stop the HTTP server"
  task :stop do
    sh %{kill -QUIT #{pid_from_file(pid_file)}} if process_running(pid_file)
  end

  desc "restart the HTTP server"
  task :restart do
    if process_running(pid_file)
      sh %{kill -USR2 #{pid_from_file(pid_file)}}
    else
      Rake::Task["srv:start"].invoke
    end
  end
end

def command
  %{unicorn master --eval "todo" --config config/unicorn.rb --daemonize}
end

def process_running(pid_file)
  if File.exist?(pid_file)
    proc = "/proc/#{pid_from_file(pid_file)}/cmdline"
    return true if File.exist?(proc) && IO.read(proc, command.length) == command
    File.delete(pid_file)
  end
  false
end

def pid_from_file(pid_file)
  IO.read(pid_file).chomp
end
