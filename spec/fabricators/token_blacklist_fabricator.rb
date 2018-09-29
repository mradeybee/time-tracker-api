Fabricator(:token_blacklist) do
  token SecureRandom.hex(80)
end
