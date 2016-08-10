class DailyDigestWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(1) }

  def perform
    User.send_daily_digest
  end
end
