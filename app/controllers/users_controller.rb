class UsersController < ApplicationController

  def signup
    email = params[:email]
    password = params[:password]
    nickname = params[:nickname] || SecureRandom.alphanumeric(8)

    user = User.find_by(email: email)
    raise Errors::NotExist.new(Errors::ALREADY_USED_EMAIL_MESSAGE) if user.present?

    new_user = User.create!(email: email, password: password, nickname: nickname)

    render_json(data: new_user)
  end
  def login
    email = params[:email]
    password = params[:password]

    user = User.find_by(email: email)
    raise Errors::NotExist.new(Errors::USER_NOT_EXIST_MESSAGE) if user.nil?

    raise Errors::InvalidRequest.new(Errors::INVALID_PASSWORD_MESSAGE) if !user.authenticate(password)

    token = JwtToken.generate_token(user_id: user.id, nickname: user.nickname)

    render_json(data: token)
  end
end
