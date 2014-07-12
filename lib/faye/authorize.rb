require 'openssl'
require 'faye/authorize/abstract'

module Faye::Authorize
  include Abstract

  def initialize(server, options)
    @secret = options[:secret]
    initialize_authorizations
    super
  end

  def destroy_client(client_id, &callback)
    remove_authorizations_for(client_id)
    super
  end

  def subscribe(client_id, channel, &callback)
    super if authorized?(
      'subscribe', 'clientId' => client_id, 'channel' => channel
    )
    callback.call(false) if callback
  end

  def publish(message, channels)
    super if authorized?('publish', message)
  end

private

  def authorized?(action, message)
    client_id, channel, data = message.values_at('clientId', 'channel', 'data')
    if action == 'publish' && channel == '/service/authorize'
      authorize(client_id, data)
      return false
    end
    channel = [action] + Faye::Channel.parse(channel)
    authorizations_for(client_id).any? do |pattern|
      authorization_pattern_matches?(channel, pattern)
    end
  end

  def authorization_pattern_matches?(channel, pattern)
    return false if channel.length < pattern.length
    channel.zip(pattern).all? do |channel, pattern|
      return true if pattern == '**'
      pattern == '*' || pattern == channel
    end
  end

  def authorize(client_id, data)
    patterns, hash = data.values_at('patterns', 'hash')
    add_authorizations(client_id, patterns) if
      valid_authorization?(patterns, hash)
  end

  def valid_authorization?(patterns, hash)
    valid_hash = OpenSSL::HMAC.hexdigest('sha256', @secret, patterns.join(','))
    # Use a constant time comparison to prevent timing attacks.
    java.security.MessageDigest.isEqual(
      valid_hash.to_java_bytes, hash.to_java_bytes
    )
  end

  def add_authorizations(client_id, patterns)
    @server.debug 'Adding authorized patterns ? for client ?', patterns, client_id
    patterns.each do |pattern|
      add_authorization_for(
        client_id, java.util.ArrayList.new(pattern.split('/'))
      )
    end
  end
end
