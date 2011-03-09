When /^I type "(.*)" and hit tab$/ do |command|
  pending
  _write_interactive(command)
  _write_interactive("\t")
  _write_interactive("\n")
end

When /^I type "(.*)" and hit tab twice$/ do |command|
  pending
  _write_interactive(command)
  _write_interactive("\t")
  _write_interactive("\t")
  _write_interactive("\n")
end
