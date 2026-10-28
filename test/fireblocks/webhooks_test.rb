# frozen_string_literal: true

require 'test_helper'
require 'openssl'

class FireblocksWebhooksTest < Minitest::Test
  RSA_KEY = OpenSSL::PKey::RSA.generate(2048).to_pem

  def setup
    Fireblocks.reset
    Fireblocks.configure do |config|
      config.api_key = 'test-api-key'
      config.private_key = RSA_KEY
      config.base_url = 'https://api.fireblocks.io'
    end
  end

  def test_list_webhooks_gets_webhook_endpoints
    result = with_http_response(
      code: '200',
      message: 'OK',
      body: '[{"id":"wh-1","status":"ENABLED"}]'
    ) do
      Fireblocks::API.list_webhooks
    end

    assert_equal 'GET', @captured_request.method
    assert_equal '/v1/webhooks', @captured_request.path
    assert_equal [{ 'id' => 'wh-1', 'status' => 'ENABLED' }], result
  end

  def test_resend_notifications_by_resource_includes_completed_notifications
    result = with_http_response(code: '202', message: 'Accepted', body: '') do
      Fireblocks::API.resend_notifications_by_resource(webhook_id: 'wh-1', resource_id: 'tx-1')
    end
    assert_equal 'POST', @captured_request.method
    assert_equal '/v1/webhooks/wh-1/notifications/resend_by_resource', @captured_request.path
    assert_equal({ 'resourceId' => 'tx-1', 'excludeStatuses' => [] }, JSON.parse(@captured_request.body))
    assert_nil result
  end

  def test_resend_webhook_still_posts_the_v1_endpoint
    result = with_http_response(code: '200', message: 'OK', body: '{"success":true}') do
      Fireblocks::API.resend_webhook('tx-1')
    end

    assert_equal 'POST', @captured_request.method
    assert_equal '/v1/webhooks/resend/tx-1', @captured_request.path
    assert_equal(
      { 'resendStatusUpdated' => true, 'resendCreated' => false },
      JSON.parse(@captured_request.body)
    )
    assert_equal({ 'success' => true }, result)
  end
end
