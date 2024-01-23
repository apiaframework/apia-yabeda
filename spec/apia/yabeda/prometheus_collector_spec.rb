# frozen_string_literal: true

require "spec_helper"
require "rack/mock"

class ApiAuth < Apia::Authenticator; end

class PermissionDeniedError < Apia::Error

  code :permission_denied
  http_status 403
  field :details, :string, null: true

end

class TestEndpoint < Apia::Endpoint

  def call
    response.add_header "x-hello", "world"
  end

end

class Test403Endpoint < Apia::Endpoint

  potential_error PermissionDeniedError

  def call
    raise_error PermissionDeniedError, details: "You do not have permission"
  end

end

class ExampleApi < Apia::API

  authenticator ApiAuth
  routes do
    get "test", endpoint: TestEndpoint
    get "permission_denied", endpoint: Test403Endpoint
  end

end

RSpec.describe Apia::Yabeda::PrometheusCollector do
  let(:app) do
    Class.new do
      def call(_env)
        [200, {}, ["Hello world!"]]
      end
    end.new
  end

  let(:apia_rack) { Apia::Rack.new(app, ExampleApi, "api/v1") }

  before(:all) do
    # Only subscribe once, so we don't trigger our collector multiple times
    Apia::Notifications.add_handler do |event, args|
      ActiveSupport::Notifications.instrument("#{event}.apia", args)
    end
  end

  before do
    # Reset metrics before each test
    Yabeda.apia.requests_total.values.clear
    Yabeda.apia.endpoint_duration.values.clear
  end

  after(:all) do
    Apia::Notifications.clear_handlers
  end

  describe "requests_total" do
    it "counts each successful request" do
      expected_labels = {
        api: "ExampleApi",
        authenticator: "ApiAuth",
        endpoint: "TestEndpoint",
        error_code: "",
        method: :get,
        route: "/test",
        status: 200
      }

      apia_rack.call(Rack::MockRequest.env_for("/api/v1/test"))
      expect(Yabeda.apia.requests_total.values).to eq(expected_labels => 1)

      apia_rack.call(Rack::MockRequest.env_for("/api/v1/test"))
      expect(Yabeda.apia.requests_total.values).to eq(expected_labels => 2)
    end

    it "counts error responses" do
      expected_labels = {
        api: "ExampleApi",
        authenticator: "ApiAuth",
        endpoint: "Test403Endpoint",
        error_code: "permission_denied",
        method: :get,
        route: "/permission_denied",
        status: 403
      }

      apia_rack.call(Rack::MockRequest.env_for("/api/v1/permission_denied"))
      expect(Yabeda.apia.requests_total.values).to eq(expected_labels => 1)
    end
  end

  describe "endpoint_duration" do
    it "measures the duration of each request" do
      apia_rack.call(Rack::MockRequest.env_for("/api/v1/test"))

      metric = Yabeda.apia.endpoint_duration.values.fetch({ status: 200, endpoint: "TestEndpoint" })
      expect(metric).to be_a(Numeric)
    end
  end
end
