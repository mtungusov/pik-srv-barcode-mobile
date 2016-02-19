%w{INT TERM USR1}.each do |signal|
  trap(signal) do
    puts "Terminate:start"
    $run = false
    sleep 5
    puts "Terminate:end"
    # exit!
  end
end
