require "rails_helper"

RSpec.describe ExamSchedulesController, type: :controller do
  describe "ExamSchedulesController" do
    it "list all exam schedules" do
      20.times do
        create(:exam_schedule)
      end

      limit = 10
      get :index, params: { page: 1, limit: limit }

      parsed_body = JSON.parse(response.body)
      pp parsed_body
      data = parsed_body["data"]

      expect(data.size).to eq(limit)
    end

    it "show exam schedule detail" do
      exam_schedule = create(:exam_schedule)

      get :show, params: { id: exam_schedule.id }

      parsed_body = JSON.parse(response.body)
      data = parsed_body["data"]

      expect(data).not_to be_nil
      expect(data["id"]).to eq(exam_schedule.id)
    end
  end
end
