# faye-authorize

An authorization mixin for the Faye pubsub server.

This is still a work in progress.

## About

After a client connects, it posts a message to `/service/authorize` with a signed array of authorized channel patterns. All attempts to `post` or `subscribe` to a channel must match at least one of the authorized patterns.

The pattern signature hash is verified with a shared secret set in the Faye options.

## Example

```
post /service/authorize
  patterns: ['publish/chats/**', 'subscribe/chats/**']
  hash: '...'
```

Post/subscribe to any channel: `*/**` or just `**`

Post/subscribe to a specific channel: `*/user/1234`

## Generating the signature hash

The signature hash is a SHA256 HMAC digest of the comma-separated list of authorized channel patterns.

```ruby
OpenSSL::HMAC.hexdigest('sha256', @secret, patterns.join(','))
```
