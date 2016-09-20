# encoding: utf-8

class MovieUploader < CarrierWave::Uploader::Base
  include CarrierWave::VideoConverter
  include ::CarrierWave::Backgrounder::Delay

  storage :file
  process :encode_video => [:mp4]
  before :store, :set_duration

  private

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(mp4 webm)
  end

  def set_duration(file)
    model.duration = FFMPEG::Movie.new(current_path).duration
    model.save!
  end
end
