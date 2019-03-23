class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  # POST /signup
  # return authenticated token upon signup
  def create
    unless user_count.zero?
      response = { record_exists: true, record_count: user_count }
      return json_response(response)
    end

    create_user
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def create_user
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = {
      message: Message.account_created,
      auth_token: auth_token,
      user_info: user.details
    }
    json_response(response, :created)
  end

  def user_count
    User.where(
      'name = :query1 OR email = :query2',
      query1: params[:name],
      query2: params[:email]
    ).size
  end
end
