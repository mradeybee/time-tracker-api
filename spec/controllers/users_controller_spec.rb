require 'rails_helper'

RSpec.describe UsersController, type: :request do

  describe 'create (POST /users)' do
    context 'with valid cridentials' do
      it 'creates user record' do
        post '/users', params: {auth: {password: 'paSSw0Rd!', email: 'james@email.com'}}

        expect(response.status).to eql 201
        expect(JSON.parse(response.body).keys).to include('jwt')
      end
    end

    context 'with invalid cridentials' do
      context 'invalid email' do
        it 'return an error if email is incorrect' do
          post '/users', params:  {auth: {password: 'paSSw0Rd!', email: 'jamesemail.com'}}
  
          expect(response.status).to eql 422
          expect(JSON.parse(response.body)['errors']).to include('Email is invalid')
        end

        it 'return an error if email is blank' do
          post '/users', params:  {auth: {password: 'paSSw0Rd!', email: ''}}
  
          expect(response.status).to eql 422
          expect(JSON.parse(response.body)['errors']).to include("Email can't be blank")
        end
      end
      
      context 'empty password' do
        it 'return an error if password is blank' do
          post '/users', params:  {auth: {password: '', email: 'james@email.com'}}
  
          expect(response.status).to eql 422
          expect(JSON.parse(response.body)['errors']).to include("Password can't be blank")
        end
      end
    end
  end
end
