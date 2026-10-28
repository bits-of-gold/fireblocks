# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'fireblocks'
require 'pry-byebug'

require 'minitest/autorun'

module FireblocksTestHTTP
  def with_http_response(code:, message:, body:, &block)
    captured = []
    starter = http_starter(read_http_response(code, message, body), captured)
    result = Net::HTTP.stub(:start, starter, &block)
    @captured_request = captured[0]
    result
  end

  private

  def read_http_response(code, message, body)
    response = Net::HTTPResponse::CODE_TO_OBJ.fetch(code).new('1.1', code, message)
    response.body = body
    response.instance_variable_set(:@read, true)
    response
  end

  def http_starter(response, captured)
    lambda do |*_args, **_kwargs, &block|
      http = Object.new
      http.define_singleton_method(:request) do |request|
        captured[0] = request
        response
      end
      block.call(http)
    end
  end
end

class Minitest::Test
  include FireblocksTestHTTP
end
