require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    context "presence" do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_presence_of(:password) }
    end

    describe 'custom email validation' do
      subject { User.new(email: 'test@email.com', password: 'paSSw0Rd') }

      context 'valid email' do
        it { is_expected.to be_valid }
      end

      context 'invalid email' do
        before do
          subject.email = 'email.com'
          subject.valid?
        end

        it { is_expected.to be_invalid }

        it 'returns an error when email is invalid' do
          expect(subject.errors[:email]).to match_array('is invalid')
        end
      end
    end
  end

  context 'generate refresh token' do
    subject { Fabricate(:user) }

    it 'generates refresh token' do
      expect(subject.refresh_token).to_not be nil
    end
  end
end
