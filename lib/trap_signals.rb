%w{INT TERM USR1}.each do |signal|
  trap(signal) do
    puts "Terminate:start"
    exit!
  end
end
