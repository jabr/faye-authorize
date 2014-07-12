module Faye::Authorize::Hazelcast
  include Faye::Authorize

private

  def initialize_authorizations
    @authorizations = @hazel.getMultiMap('faye.authorizations')
  end

  def remove_authorizations_for(client_id)
    @authorizations.remove(client_id)
  end

  def authorizations_for(client_id)
    @authorizations.get(client_id)
  end

  def add_authorization_for(client_id, authorization)
    @authorizations.put(client_id, authorization)
  end

  def disconnect_authorizations
  end
end
