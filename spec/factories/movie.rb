FactoryGirl.define do
  factory :movie do
    state       Movie.state_machine.states[:scheduled].value
    start_time  "00:0#{1..9}"
    last_name   "00:1#{1..9}"
    user
  end
end
