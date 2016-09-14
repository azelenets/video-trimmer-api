class Movie
  include Mongoid::Document

  belongs_to :user

  field :start_time,  type: Time
  field :end_time,    type: Time

  validates :start_time, presence: true
  validates :end_time,   presence: true

  state_machine initial: :scheduled do
    state :scheduled,   value: 0
    state :processing,  value: 1
    state :done,        value: 2
    state :failed,      value: 3
  end
end
