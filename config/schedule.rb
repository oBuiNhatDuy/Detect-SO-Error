ENV.each { |k, v| env(k, v) }

set :environment, ENV["RAILS_ENV"]
set :output, "./log/cron.log"
set :chronic_options, hours24: true

every 6.hours do
  rake "stack_overflow:get_new_question"
end
