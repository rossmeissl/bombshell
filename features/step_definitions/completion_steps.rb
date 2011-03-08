When /^I type "(.*)" and hit tab$/ do |command|
  puts "sending #{(command + "\t").inspect}"
  type(command + "\t")
end
