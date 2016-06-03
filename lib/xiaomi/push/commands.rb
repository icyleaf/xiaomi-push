require 'xiaomi/push/commands/message'
require 'xiaomi/push/commands/feedback'

unless defined?(Dotenv)
  require 'dotenv'
  Dotenv.load
end