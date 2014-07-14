#! /usr/bin/env ruby

File.readlines("/usr/local/share/zookeepers.list").each do |line|
  output = `mesos-resolve zk://#{line}:2181/mesos 2>/dev/null`
  if $?.to_i == 0
    $stdout.puts output
    Kernel.exit(0)
  end
end

$stderr.puts "ERROR: Could not find live Zookeeper in /usr/local/share/zookeepers.list."
Kernel.exit(1)