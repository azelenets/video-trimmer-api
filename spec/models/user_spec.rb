describe User do
  subject { create(:user) }

  context 'ActiveRecord associations' do
    it { is_expected.to have_many(:movies) }
  end
end
