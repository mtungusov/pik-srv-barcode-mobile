%w{INT TERM USR1}.each do |signal|
  trap(signal) do
    puts "Terminate:start"
    sleep 5
    puts "Terminate:end"
    # exit!
  end
end
