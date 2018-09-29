require 'rails_helper'

RSpec.describe TokenGenerator, type: :concern do
  let!(:user) { Fabricate(:user) }

  describe 'secret' do
    it 'generates token' do
      expect(TokenGenerator.secret).to eql ENV['SECRET']
    end
  end

  describe 'generate_token' do
    it 'generates token' do
      expect(TokenGenerator.generate_token({user: user.id})).to_not be nil
    end
  end

  describe 'decode_token' do
    it 'decodes token' do
      token = TokenGenerator.generate_token({user: user.id})
      expect(TokenGenerator.decode_token(token)['user']).to eql user.id
    end
  end
end
