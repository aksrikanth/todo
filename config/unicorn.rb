preload_app true

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  child_pid = server.config[:pid].sub('.pid', ".#{worker.nr}.pid")
  IO.write(child_pid, Process.pid)
end

app_root = File.expand_path('../..', __FILE__)

stderr_path "#{app_root}/log/unicorn.log"
stdout_path "#{app_root}/log/unicorn.log"

timeout 60
worker_processes 1
pid "#{app_root}/tmp/pids/unicorn.pid"
listen '0.0.0.0:3000', backlog: 2048
