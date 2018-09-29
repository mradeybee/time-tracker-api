require 'rails_helper'

RSpec.describe AuthController, type: :request do
  include HeaderHelper
  let!(:user) { Fabricate(:user, password: 'paSSw0Rd!', email: 'james@email.com') }

  describe 'login (POST /login)' do

    context 'with valid cridentials' do
      it 'logs in user' do
        post '/auth/login', params: {auth: {password: 'paSSw0Rd!', email: 'james@email.com'}}

        expect(response.status).to eql 200
        expect(JSON.parse(response.body).keys).to include('jwt')
      end
    end

    context 'with invalid cridentials' do
      it 'return an error if email is incorrect' do
        post '/auth/login', params:  {auth: {password: 'paSSw0Rd!', email: 'john@email.com'}}

        expect(response.status).to eql 422
        expect(JSON.parse(response.body)['errors']).to include('Invalid Cridentials')
      end

      it 'return an error if password is incorrect' do
        post '/auth/login', params:  {auth: {password: 'passw0Rd!', email: 'james@email.com'}}

        expect(response.status).to eql 422
        expect(JSON.parse(response.body)['errors']).to include('Invalid Cridentials')
      end
    end
  end
  
  describe 'logout (POST /logout)' do
    context 'with valid cridentials' do
      it 'blacklists the token' do
        expect { post '/auth/logout', params: {auth: {refresh_token: user.refresh_token}}, headers: auth_header(user) }.to change(TokenBlacklist, :count).by(1)
      end

      it 'logs out user' do
        post '/auth/logout', params: {auth: {refresh_token: user.refresh_token}}, headers: auth_header(user)

        expect(response.status).to eql 204
        expect(response.body).to eql ''
      end
    end

    context 'with invalid cridentials' do
      it 'return an error if refresh token is invalid' do
        post '/auth/logout', params: {auth: {refresh_token: SecureRandom.hex(80)}}, headers: invalid_auth_header

        expect(response.status).to eql 422
        expect(JSON.parse(response.body)['errors']).to include('Invalid Access Token')
      end
    end
  end
  
  describe 'refresh_token (POST /refresh)' do
    context 'with valid cridentials' do
      it 'logs out user' do
        post '/auth/refresh', params: {auth: {refresh_token: user.refresh_token}}, headers: auth_header(user)

        expect(response.status).to eql 200
        expect(JSON.parse(response.body).keys).to include('jwt')
      end
    end

    context 'with invalid cridentials' do
      it 'return an error if refresh token is invalid' do
        post '/auth/refresh', params: {auth: {refresh_token: SecureRandom.hex(80)}}, headers: invalid_auth_header

        expect(response.status).to eql 422
        expect(JSON.parse(response.body)['errors']).to include('Invalid Access Token')
      end
    end
  end
end
