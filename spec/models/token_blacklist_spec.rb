require 'rails_helper'

RSpec.describe TokenBlacklist, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:token) }
  end
end
