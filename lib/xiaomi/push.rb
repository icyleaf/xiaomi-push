require "xiaomi/push/version"
require "xiaomi/push/error"
require "xiaomi/push/const"
require "xiaomi/push/client"

require "xiaomi/push/devices/ios"
require "xiaomi/push/devices/android"

require "xiaomi/push/services/message"
require "xiaomi/push/services/topic"
require "xiaomi/push/services/alias"
require "xiaomi/push/services/feedback"


unless defined?(Dotenv)
  require 'dotenv'
  Dotenv.load
end

module Xiaomi
  module Push
  end
end
