FactoryBot.define do
  factory :exam_schedule do
    sequence(:date) { |n| (n + 1).weeks.after }
    start_time { Time.zone.now.beginning_of_hour }
    end_time { (Time.zone.now + 5.hour).end_of_hour }
    total_slots_count { 50000 }
  end
end
