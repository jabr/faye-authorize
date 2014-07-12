require 'set'

module Faye::Authorize::Memory
  include Faye::Authorize

private

  def initialize_authorizations
    @authorizations = {}
  end

  def remove_authorizations_for(client_id)
    @authorizations.delete(client_id)
  end

  def authorizations_for(client_id)
    @authorizations.fetch(client_id, [])
  end

  def add_authorization_for(client_id, authorization)
    (@authorizations[client_id] ||= Set.new) << authorization
  end

  def disconnect_authorizations
    @authorizations = {}
  end
end
