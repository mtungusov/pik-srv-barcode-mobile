at_exit {
  puts "Terminate:start"
  $run = false
  sleep 5
  puts "Terminate:end"
}
