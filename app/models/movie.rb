class Movie
  include Mongoid::Document

  belongs_to :user

  field :file_tmp,    type: String
  field :start_time,  type: Time
  field :end_time,    type: Time
  field :duration,    type: Float

  mount_uploader :file, MovieUploader
  store_in_background :file, ProcessMovieWorker

  validates :start_time, presence: true
  validates :end_time,   presence: true

  state_machine initial: :scheduled do
    before_transition processing: :done do |movie, transition|
      movie.duration = FFMPEG::Movie.new(movie.file.path).duration
    end

    state :scheduled,   value: 0
    state :processing,  value: 1
    state :done,        value: 2 do
      validates :duration, presence: true
    end
    state :failed,      value: 3

    event(:process) { transition %i(scheduled failed) => :processing }
    event(:done) { transition :processing => :done }
    event(:fails) { transition any => :failed }
  end
end
