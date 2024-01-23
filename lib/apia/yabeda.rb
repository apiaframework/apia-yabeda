# frozen_string_literal: true

require "apia/yabeda/prometheus_collector"
require "apia/yabeda/version"

module Apia
  module Yabeda
  end
end

collector = Apia::Yabeda::PrometheusCollector.new
collector.start
