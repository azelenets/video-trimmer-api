module V1
  class SessionsController < Devise::SessionsController
    # include SessionsDoc

    api :POST, 'v1/sign_in', 'User sign.', version: '1'
    formats [:json]
    param :user, Hash, required: true do
      param :email, String, desc: 'User email.', required: true
      param :password, String, desc: 'User password.', required: true
    end
    error '401', 'Unauthorized'
    example 'Success:
{
  "_id": {
    "$oid": "57d6a2b919924ee179905325"
  },
  "authentication_token": "_QzPYa_CfDtwRuP4DL5t",
  "email": "test@test.com"
}'
    example 'Errors:
{
  "error": "You need to sign in or sign up before continuing."
}'
    def create
      super
    end

    api :DELETE, 'v1/sign_out', 'User sign out.', version: '1'
    formats [:json]
    header 'X-User-Email', 'User email. Required if "user_email" param is blank.', required: true
    header 'X-User-Token', 'User authentication token. Required if "user_token" param is blank.', required: true
    error '401', 'Unauthorized'
    def destroy
      super
    end

    private

    def respond_to_on_destroy
      render json: {}, status: :no_content
    end

  end
end
