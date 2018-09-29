require 'rails_helper'

RSpec.describe TimerController, type: :request do
  include HeaderHelper
  let(:user) { Fabricate(:user) }

  before do
    5.times { Fabricate(:timer, user: user) }
    5.times { Fabricate(:timer) } # Createing timer for other users to make sure that the timer returned is scopped to the current user.
  end

  describe 'user_timers (GET /user_timers)' do
    context 'with valid authorization' do
      it 'gets all time logged by a user' do
        get '/user_timers', headers: auth_header(user)

        expect(response.status).to eql 200
        expect(JSON.parse(response.body).keys).to include('timers')
        expect(JSON.parse(response.body)['timers'].size).to eql 5
      end
    end
  
    context 'with invalid authorization' do
      it 'returns access token error' do
        get '/user_timers', headers: invalid_auth_header

        expect(response.status).to eql 422
        expect(JSON.parse(response.body)['errors']).to eql 'Invalid Access Token'
      end
    end
  end

  describe 'timers (POST /timers)' do
    context 'with valid cridentials' do
      it 'creates user timers' do
        post '/timer', params: {timer: {seconds: 2613, start_at: '2018-09-28 19:10:16', stop_at: '2018-09-28 19:10:19'}}, headers: auth_header(user)

        expect(response.status).to eql 201
        expect(JSON.parse(response.body).keys).to include('timers')
        expect(JSON.parse(response.body)['timers'].size).to eql 6
      end
    end

    context 'with invalid cridentials' do
      context 'invalid access token' do
        it 'returns access token error' do
          post '/timer', params: {timer: {seconds: 2613, start_at: '2018-09-28 19:10:16', stop_at: '2018-09-28 19:10:19'}}, headers: invalid_auth_header
          
  
          expect(response.status).to eql 422
          expect(JSON.parse(response.body)['errors']).to eql 'Invalid Access Token'
        end
      end
      
      context 'empty timer data' do
        it 'return an error if seconds is blank' do
          post '/timer', params:  {timer: {seconds: nil, start_at: '2018-09-28 19:10:16', stop_at: '2018-09-28 19:10:19'}}, headers: auth_header(user)
  
          expect(response.status).to eql 422
          expect(JSON.parse(response.body)['errors']).to include("Seconds can't be blank")
        end
        
        it 'return an error if start_at is blank' do
          post '/timer', params:  {timer: {seconds: 2613, start_at: nil, stop_at: '2018-09-28 19:10:19'}}, headers: auth_header(user)
  
          expect(response.status).to eql 422
          expect(JSON.parse(response.body)['errors']).to include("Start at can't be blank")
        end
        
        it 'return an error if stop_at is blank' do
          post '/timer', params:  {timer: {seconds: 2613, 'start_at': '2018-09-28 19:10:16', stop_at: nil}}, headers: auth_header(user)
  
          expect(response.status).to eql 422
          expect(JSON.parse(response.body)['errors']).to include("Stop at can't be blank")
        end
      end
    end
  end
end
