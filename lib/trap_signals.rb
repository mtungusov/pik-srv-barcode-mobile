%w{INT TERM USR1}.each do |signal|
  trap(signal) do
    puts "Terminate:start"
    Workers.shutdown
    Cache.shutdown
    puts "Terminate:end"
  end
end
