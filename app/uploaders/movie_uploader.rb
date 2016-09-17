# encoding: utf-8

class MovieUploader < CarrierWave::Uploader::Base
  include CarrierWave::VideoConverter

  storage :file
  process :encode_video => [:mp4]
  before :cache, :change_model_state
  before :store, :set_duration

  private

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(mp4 webm)
  end

  def change_model_state(file)
    model.process!
  end

  def set_duration(file)
    model.duration = FFMPEG::Movie.new(current_path).duration
  end
end
