require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "UsersController" do
    it "sign up" do
      post :signup, params: { email: "test@example.com", password: "password", nickname: "test" }

      parsed_body = JSON.parse(response.body)
      data = parsed_body["data"]

      expect(data).not_to be_nil
    end

    it "login" do
      user = create(:user)

      get :login, params: { email: user.email, password: user.password }

      parsed_body = JSON.parse(response.body)
      data = parsed_body["data"]

      expect(data).not_to be_nil
    end
  end
end
