# frozen_string_literal: true

require 'test_helper'
require 'openssl'

class FireblocksRequestTest < Minitest::Test
  RSA_KEY = OpenSSL::PKey::RSA.generate(2048).to_pem
  NOT_FOUND_BODY = '{"message":"No notifications found","code":1009}'

  def setup
    Fireblocks.reset
    Fireblocks.configure do |config|
      config.api_key = 'test-api-key'
      config.private_key = RSA_KEY
      config.base_url = 'https://api.fireblocks.io'
    end
  end

  def test_post_accepts_http_202_with_an_empty_body
    result = with_http_response(code: '202', message: 'Accepted', body: '') do
      Fireblocks::Request.post(path: '/v1/example', body: { resourceId: 'tx-1' })
    end

    assert_nil result
  end

  def test_post_accepts_http_202_when_the_body_is_nil
    result = with_http_response(code: '202', message: 'Accepted', body: nil) do
      Fireblocks::Request.post(path: '/v1/example', body: { resourceId: 'tx-1' })
    end

    assert_nil result
  end

  def test_post_returns_parsed_json_for_an_ok_response
    result = with_http_response(code: '200', message: 'OK', body: '{"success":true}') do
      Fireblocks::Request.post(path: '/v1/example', body: { name: 'vault' })
    end

    assert_equal({ 'success' => true }, result)
  end

  def test_post_raises_the_parsed_body_when_the_response_is_not_ok
    error = assert_raises(Fireblocks::Request::Error) do
      with_http_response(code: '400', message: 'Bad Request', body: NOT_FOUND_BODY) do
        Fireblocks::Request.post(path: '/v1/example', body: {})
      end
    end
    assert_includes error.message, 'No notifications found'
    assert_includes error.message, '1009'
  end

  def test_post_still_parses_an_empty_ok_body
    assert_raises(JSON::ParserError) do
      with_http_response(code: '200', message: 'OK', body: '') do
        Fireblocks::Request.post(path: '/v1/example', body: {})
      end
    end
  end

  def test_post_returns_parsed_json_for_an_accepted_response
    result = with_http_response(code: '202', message: 'Accepted', body: '{"total":2}') do
      Fireblocks::Request.post(path: '/v1/example', body: {})
    end

    assert_equal({ 'total' => 2 }, result)
  end
end
