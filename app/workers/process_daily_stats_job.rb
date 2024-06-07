class ProcessDailyStatsJob
  include Sidekiq::Worker

  def perform
    daily_record = DailyRecord.create(date: Date.today)
    male_count = User.total_gender('male').count
    female_count = User.total_gender('female').count

    male_avg_age = User.total_gender('male').average(:age)
    female_avg_age = User.total_gender('female').average(:age)
    daily_record.update!(male_count: male_count, female_count: female_count, male_avg_age: male_avg_age, female_avg_age: female_avg_age)
  end
end
