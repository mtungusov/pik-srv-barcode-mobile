%w{INT TERM USR1}.each do |signal|
  trap(signal) do
    puts "Terminate:start"
    Workers.shutdown
    puts "Terminate:end"
  end
end
