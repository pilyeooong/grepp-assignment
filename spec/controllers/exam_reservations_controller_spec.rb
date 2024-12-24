require "rails_helper"

RSpec.describe ExamReservationsController, type: :controller do
  describe "ExamReservationsController" do
    it "list all exam reservations" do
      admin = create(:user, user_level: User::ADMIN_USER_LEVEL)

      20.times do |n|
        user = create(:user)
        exam_schedule = create(:exam_schedule)
        create(:exam_reservation, user: user, exam_schedule: exam_schedule)
      end

      limit = 10
      headers = get_user_token_headers(admin)
      request.headers.merge! headers

      get :index, params: { page: 1, limit: limit }

      parsed_body = JSON.parse(response.body)
      data = parsed_body["data"]

      expect(data.size).to eq(limit)
    end

    it "should throw exception if normal user tries to list  exam reservations" do
      user = create(:user)

      5.times do |n|
        user = create(:user)
        exam_schedule = create(:exam_schedule)
        create(:exam_reservation, user: user, exam_schedule: exam_schedule)
      end

      limit = 10
      headers = get_user_token_headers(user)
      request.headers.merge! headers

      get :index, params: { page: 1, limit: limit }

      parsed_body = JSON.parse(response.body)
      error = parsed_body["error"]

      expect(error["message"]).to eq(Errors::FORBIDDEN_MESSAGE)
    end

    it "list all my reservations" do
      user = create(:user)

      20.times do
        exam_schedule = create(:exam_schedule)
        create(:exam_reservation, user: user, exam_schedule: exam_schedule)
      end

      limit = 10
      headers = get_user_token_headers(user)
      request.headers.merge! headers

      get :my_reservations, params: { page: 1, limit: limit }

      parsed_body = JSON.parse(response.body)
      data = parsed_body["data"]

      expect(data.size).to eq(limit)
    end

    it "list all confirmed reservations" do
      limit = 10
      confirmed_count = 5

      user = create(:user)

      10.times do
        exam_schedule = create(:exam_schedule)
        create(:exam_reservation, user: user, exam_schedule: exam_schedule)
      end

      confirmed_count.times do
        exam_schedule = create(:exam_schedule)
        create(:exam_reservation, user: user, exam_schedule: exam_schedule, is_confirmed: true, confirmed_at: Time.zone.now)
      end
      headers = get_user_token_headers(user)
      request.headers.merge! headers

      get :my_reservations, params: { page: 1, limit: limit, is_confirmed: true }

      parsed_body = JSON.parse(response.body)
      data = parsed_body["data"]

      expect(data.size).to eq(confirmed_count)
    end

    it "list not confirmed reservations" do
      limit = 10
      not_confirmed_count = 5

      user = create(:user)

      10.times do
        exam_schedule = create(:exam_schedule)
        create(:exam_reservation, user: user, exam_schedule: exam_schedule, is_confirmed: true, confirmed_at: Time.zone.now)
      end

      not_confirmed_count.times do
        exam_schedule = create(:exam_schedule)
        create(:exam_reservation, user: user, exam_schedule: exam_schedule)
      end
      headers = get_user_token_headers(user)
      request.headers.merge! headers

      get :my_reservations, params: { page: 1, limit: limit, is_confirmed: false }

      parsed_body = JSON.parse(response.body)
      data = parsed_body["data"]

      expect(data.size).to eq(not_confirmed_count)
    end

    it "exam reservation detail" do
      user = create(:user)

      exam_schedule = create(:exam_schedule)
      exam_reservation = create(:exam_reservation, user: user, exam_schedule: exam_schedule, is_confirmed: true, confirmed_at: Time.zone.now)

      headers = get_user_token_headers(user)
      request.headers.merge! headers

      get :show, params: { exam_reservation_id: exam_reservation.id }

      parsed_body = JSON.parse(response.body)
      data = parsed_body["data"]

      expect(data).not_to be_nil
      expect(data["id"]).to eq(exam_reservation.id)
    end

    it "create exam reservation" do
      user = create(:user)

      exam_schedule = create(:exam_schedule)

      headers = get_user_token_headers(user)
      request.headers.merge! headers

      post :create, params: { exam_schedule_id: exam_schedule.id }

      parsed_body = JSON.parse(response.body)
      data = parsed_body["data"]

      expect(data).not_to be_nil
    end

    it "raise exception if exam reservation is full" do
      user = create(:user)

      exam_schedule = create(:exam_schedule, total_slots_count: 10)
      10.times do
        user = create(:user)
        create(:exam_reservation, exam_schedule: exam_schedule, user: user)
      end

      headers = get_user_token_headers(user)
      request.headers.merge! headers

      post :create, params: { exam_schedule_id: exam_schedule.id }

      parsed_body = JSON.parse(response.body)
      error = parsed_body["error"]

      expect(error).not_to be_nil
      expect(error["message"]).to eq(Errors::EXAM_RESERVATION_SLOTS_FULL_MESSAGE)
    end

    it "update exam reservation" do
      user = create(:user)

      exam_schedule = create(:exam_schedule, total_slots_count: 10)
      exam_reservation = create(:exam_reservation, user: user, exam_schedule: exam_schedule)

      new_exam_schedule = create(:exam_schedule, total_slots_count: 10)

      headers = get_user_token_headers(user)
      request.headers.merge! headers

      patch :update, params: { exam_reservation_id: exam_reservation.id, exam_schedule_id: new_exam_schedule.id }

      parsed_body = JSON.parse(response.body)
      data = parsed_body["data"]

      expect(data).not_to be_nil
      expect(exam_reservation.reload.exam_schedule_id).to eq(new_exam_schedule.id)
    end

    it "destroy exam reservation" do
      user = create(:user, user_level: User::ADMIN_USER_LEVEL)
      normal_user = create(:user)

      exam_schedule = create(:exam_schedule, total_slots_count: 10)
      exam_reservation = create(:exam_reservation, user: user, exam_schedule: exam_schedule, is_confirmed: true)
      create(:exam_reservation, user: normal_user, exam_schedule: exam_schedule, is_confirmed: true)

      headers = get_user_token_headers(user)
      request.headers.merge! headers

      delete :destroy, params: { exam_reservation_id: exam_reservation.id }

      parsed_body = JSON.parse(response.body)
      data = parsed_body["data"]

      confirmed_reservations_count = ExamReservation.where(exam_schedule_id: exam_schedule.id, is_confirmed: true).count

      expect(data).not_to be_nil
      expect(confirmed_reservations_count).to eq(1)
      expect(exam_reservation.reload.deleted_at).not_to be_nil
    end

    it "confirm exam reservation" do
      user = create(:user, user_level: User::ADMIN_USER_LEVEL)
      normal_user = create(:user)

      exam_schedule = create(:exam_schedule, total_slots_count: 10)
      exam_reservation = create(:exam_reservation, user: normal_user, exam_schedule: exam_schedule, is_confirmed: false)

      headers = get_user_token_headers(user)
      request.headers.merge! headers

      post :confirm_reservation, params: { exam_reservation_id: exam_reservation.id }

      parsed_body = JSON.parse(response.body)
      data = parsed_body["data"]

      confirmed_reservations_count = ExamReservation.where(exam_schedule_id: exam_schedule.id, is_confirmed: true).count

      expect(data).not_to be_nil
      expect(exam_reservation.reload.is_confirmed).to eq(true)
      expect(confirmed_reservations_count).to eq(1)
    end
  end
end
