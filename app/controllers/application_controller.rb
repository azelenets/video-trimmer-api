class ApplicationController < ActionController::API
  respond_to :json
  acts_as_token_authentication_handler_for User

  # Convenience methods for serializing models:
  def serialize_model(model, options = {})
    options[:is_collection] = false
    JSONAPI::Serializer.serialize(model, options)
  end

  def serialize_models(models, options = {})
    options[:is_collection] = true
    JSONAPI::Serializer.serialize(models, options)
  end

  def serialize_errors(errors)
    JSONAPI::Serializer.serialize_errors(errors)
  end
end
