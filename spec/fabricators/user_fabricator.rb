Fabricator(:user) do
  password "paSSw0Rd!"
  email { Fabricate.sequence(:email) { |index| "user#{index}@email.com" } }
  refresh_token SecureRandom.hex(80)
end
