5.times do |n|
  User.find_or_create_by!(email: "test#{n}@gmail.com") do |user|
    user.password = "test"
    user.nickname = "테스터#{n}"
  end
end

10.times do |n|
  ExamSchedule.create!(
    date: Date.today + n.day,
    start_time: Time.now.beginning_of_hour,
    end_time: (Time.now + 6.hour).end_of_hour,
    total_slots_count: 50000,
    confirmed_slots_count: 0,
  )
end

pp "seed done"
