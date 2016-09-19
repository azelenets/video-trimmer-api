module CarrierWave
  module VideoConverter
    extend ActiveSupport::Concern
    module ClassMethods
      def encode_video(target_format)
        process encode_video: [target_format]
      end
    end

    def encode_video(format='mp4')
      cache_stored_file! if !cached?

      directory = File.dirname(current_path)
      tmp_path  = File.join(directory, 'tmpfile')
      File.rename(current_path, tmp_path)

      transcoding_options = {
          video_codec: 'libx264',
          x264_vprofile: 'baseline',
          audio_codec: 'aac',
          audio_bitrate: 64,
          audio_sample_rate: 44100,
          audio_channels: 1,
          custom: %W(-ss #{model.start_time.strftime('%H:%M:%S')} -to #{model.end_time.strftime('%H:%M:%S')})
      }
      ffmpeg_movie = FFMPEG::Movie.new(tmp_path)
      ffmpeg_movie.transcode(current_path, transcoding_options) do |progress|
        $redis.set(model.id, { progress: progress }.to_json)
      end

      fixed_name = File.basename(current_path, '.*') + "." + format.to_s
      File.rename(File.join(directory, fixed_name), current_path)
      File.delete(tmp_path)
    end

    private
    def prepare!
      cache_stored_file! if !cached?
    end
  end
end