require 'rails_helper'

RSpec.describe Timer, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:seconds) }
    it { is_expected.to validate_presence_of(:start_at) }
    it { is_expected.to validate_presence_of(:stop_at) }
  end
end
