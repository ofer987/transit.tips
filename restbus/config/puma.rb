# binding.pry
# return if Rails.env.development?

APP_DIR = File.expand_path("../..", __FILE__)
SHARED_DIR = "#{APP_DIR}/shared"
LOG_DIR = "#{SHARED_DIR}/log"
LOG = "#{LOG_DIR}/puma.stdout.log"
ERROR = "#{LOG_DIR}/puma.stderr.log"

PIDS_DIR = "#{SHARED_DIR}/pids"
PID = "#{PIDS_DIR}/puma.pid"
STATE = "#{PIDS_DIR}/puma.state"

def setup
  workers Integer(ENV['WEB_CONCURRENCY'] || 1)
  threads_count = Integer(ENV['MAX_THREADS'] || 1)
  threads threads_count, threads_count

  create_files

  # Set up socket location
  bind "unix://#{SHARED_DIR}/sockets/puma.sock"

  # Logging
  stdout_redirect LOG, ERROR, true

  # Set master PID and state locations
  pidfile PID
  state_path STATE
  activate_control_app

  preload_app!
  environment Rails.env

  on_worker_boot do
    require "active_record"

    ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
    ActiveRecord::Base.establish_connection(
      YAML.load_file("#{APP_DIR}/config/database.yml")[Rails.env])
  end
end

def create_files
  FileUtils.mkdir_p(SHARED_DIR) unless Dir.exists?(SHARED_DIR)
  FileUtils.mkdir_p(LOG_DIR) unless Dir.exists?(LOG_DIR)
  FileUtils.touch(LOG) unless File.exists?(LOG)
  FileUtils.touch(ERROR) unless File.exists?(ERROR)

  FileUtils.mkdir_p(PIDS_DIR) unless Dir.exists?(PIDS_DIR)
  FileUtils.touch(PID) unless File.exists?(PID)
  FileUtils.touch(STATE) unless File.exists?(STATE)
end

setup
