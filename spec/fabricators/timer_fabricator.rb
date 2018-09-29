Fabricator(:timer) do
  user    { Fabricate(:user) }
  seconds    6061
  start_at   DateTime.now
  stop_at    DateTime.now + 1.minute
end
