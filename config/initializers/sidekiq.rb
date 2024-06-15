require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/cron/web' 

cron_jobs = {
  'fetch_users_every_30_minutes' => {
    'class' => 'FetchUsersJob',
    'cron'  => "*/30 * * * *"  
  }
}

Sidekiq::Cron::Job.load_from_hash! cron_jobs