require 'rails_helper'

RSpec.describe User do
  subject { create(:user) }

  it { is_expected.to have_many(:movies) }
end
