FactoryGirl.define do
  factory :movie do
    state       Movie.state_machine.states[:scheduled].value
    start_time  "00:0#{1..5}"
    end_time    "00:0#{5..9}"
    file        Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'test_example.mp4'))
    user
  end
end
