%w{INT TERM USR1}.each do |signal|
  trap(signal) do
    puts "Terminate:start"
    $consumer.wakeup
    puts "Terminate:end"
  end
end
