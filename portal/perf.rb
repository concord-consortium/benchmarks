#!/usr/bin/env ruby
begin
  require 'trollop'
rescue LoadError
  puts "Trollop not installed! Run 'gem install trollop' and try again."
  exit
end

opts = Trollop::options do
  version "perf 1.0"
  banner <<-BANNER
perf is a simple wrapper around httperf which allows you to run some benchmarks and performance tests easily

Usage:
  perf.rb [options] <session_file> [<session_file> <session_file> ... ]
where [options] are:
BANNER
  opt :server,      "Server to send requests to",               :default => 'localhost'
  opt :port,        "Port on which the server is listening",    :default => 3000
  opt :rate,        "Number of requests per second to attempt", :default => 10.0
  opt :sessions,    "Number of sessions to start",              :default => 100
  opt :think_time,  "Time between session requests",            :default => 0.1
  opt :print_reply, "Report replies",                           :default => false
  opt :timeout,     "Timeout connecting to the server",         :default => 15
  opt :debug,       "Turn on httperf debugging",                :default => false
end

cmd_base = "httperf --hog"
cmd_base << " --server #{opts[:server]}"
cmd_base << " --port #{opts[:port]}"
cmd_base << " --timeout #{opts[:timeout]}"
cmd_base << " --rate #{opts[:rate]}"
cmd_base << " --session-cookie"
cmd_base << " --print-reply" if opts[:print_reply]
cmd_base << " --debug 1" if opts[:debug]
while sess_file = ARGV.shift
  exec cmd_base + " --wsesslog #{opts[:sessions]},#{opts[:think_time]},#{sess_file}"
end
