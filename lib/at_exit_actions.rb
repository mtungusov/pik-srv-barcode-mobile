at_exit {
  puts "Terminate:at_exit:start"
  Db.pool.shutdown { |con| con.close }
  sleep 1
  puts "Terminate:at_exit:end"
  exit!
}
