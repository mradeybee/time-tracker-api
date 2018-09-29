module HeaderHelper
  def auth_header(user)
    { 'Authorization' => TokenGenerator.generate_token({user: user.id}) }
  end
  
  def invalid_auth_header
    { 'Authorization' => TokenGenerator.generate_token({user: 0}) }
  end
end