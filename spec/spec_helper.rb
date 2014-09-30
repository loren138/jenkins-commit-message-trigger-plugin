module Jenkins
  module Tasks
    class BuildWrapper
      def self.display_name(str) ; end
    end
  end
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'models/commit_message_trigger_wrapper'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.raise_errors_for_deprecations!
end
