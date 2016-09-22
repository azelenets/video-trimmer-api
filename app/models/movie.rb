class Movie
  include Mongoid::Document

  belongs_to :user

  field :file_tmp,    type: String
  field :start_time,  type: Time
  field :end_time,    type: Time
  field :duration,    type: Float

  mount_uploader :file, MovieUploader, validate_integrity: true, validate_processing: true, validate_download: true
  store_in_background :file, ProcessMovieWorker

  validates :file_tmp,   presence: true, unless: :file
  validates :file,       presence: true, unless: :file_tmp
  validates :start_time, presence: true
  validates :end_time,   presence: true
  validate  :end_time_greater_than_start_time

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

  private

  def end_time_greater_than_start_time
    if (start_time && end_time) &&  start_time > end_time
      errors.add(:start_time, "can't be greater than end time")
    end
  end
end
