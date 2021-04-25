workers Integer(ENV['WEB_CONCURRENCY'] || 1)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 1)
threads 8, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end

before_fork do
  require 'puma_worker_killer'
  PumaWorkerKiller.config do |config|
    config.ram           = 585 # mb
    config.frequency     = 1    # seconds
    config.percent_usage = 1
    config.rolling_restart_frequency = false
  end
  PumaWorkerKiller.start
end
