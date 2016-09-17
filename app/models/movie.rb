class Movie
  include Mongoid::Document

  belongs_to :user

  field :start_time,  type: Time
  field :end_time,    type: Time
  field :duration,    type: Time

  mount_uploader :file, MovieUploader

  state_machine initial: :scheduled do
    state :scheduled,   value: 0 do
      validates :start_time, presence: true
      validates :end_time,   presence: true
    end
    state :processing,  value: 1
    state :done,        value: 2 do
      validates :duration,   presence: true
    end
    state :failed,      value: 3

    event :process do
      transition %i(scheduled failed) => :processing
    end
  end
end
