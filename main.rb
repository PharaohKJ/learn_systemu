# coding: utf-8
require 'systemu'

stdin = nil
cmd = 'sleep 10'

chars = %w{ | / - \\ } # for spin indicator
@status, @stdout, @stderr = systemu(cmd, stdin: stdin) do |pid|
  begin
    opt = Process::WNOHANG | Process::WUNTRACED
    while Process.waitpid(pid, opt) != pid
      print "#{chars[0]}"
      sleep 0.25
      chars.push chars.shift
    end
  rescue Errno::ECHILD => _e
    # ECHILD : posix で 'すでに終了している'
  rescue => e
    p e
  end
end
