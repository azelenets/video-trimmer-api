module V1
  class MovieSerializer < BaseSerializer
    attribute(:state) { object.state_name }
    attribute(:start_time) { object.start_time.strftime('%H:%M:%S') }
    attribute(:end_time) { object.end_time.strftime('%H:%M:%S') }
    attribute(:duration)
    attribute(:file) { object.file.url }
  end
end
