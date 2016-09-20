module Api
  module V1
    class BaseSerializer
      include JSONAPI::Serializer

      def self_link
        "/v1/#{super}"
      end
    end
  end
end
