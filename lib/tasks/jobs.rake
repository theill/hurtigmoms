namespace :jobs do
  desc "Start a delayed_job worker."
  task :work => [:environment] do
    Delayed::Worker.new(:quiet => true, :min_priority => ENV['MIN_PRIORITY'], :max_priority => ENV['MAX_PRIORITY']).start
  end
end
