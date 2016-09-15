describe Movie do
  subject { create(:movie) }

  describe 'ActiveModel validations' do
    it{ is_expected.to validate_presence_of(:start_time) }
    it{ is_expected.to validate_presence_of(:end_time) }
  end

  context 'ActiveRecord associations' do
    it { is_expected.to belong_to(:user) }
  end
end
