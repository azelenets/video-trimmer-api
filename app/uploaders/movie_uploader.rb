# encoding: utf-8

class MovieUploader < CarrierWave::Uploader::Base
  include CarrierWave::VideoConverter
  include ::CarrierWave::Backgrounder::Delay

  storage :file
  process :encode_video => [:mp4]

  private

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(mp4 webm)
  end
end
