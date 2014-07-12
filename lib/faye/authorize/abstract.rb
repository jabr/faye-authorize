module Faye::Authorize::Abstract
private
  def initialize_authorizations
    raise NotImplementedError('Faye::Authorize#initialize_authorizations')
  end

  def remove_authorizations_for(client_id)
    raise NotImplementedError('Faye::Authorize#initialize_authorizations')
  end

  def authorizations_for(client_id)
    raise NotImplementedError('Faye::Authorize#initialize_authorizations')
  end

  def add_authorization_for(client_id, authorization)
    raise NotImplementedError('Faye::Authorize#initialize_authorizations')
  end

  def disconnect_authorizations
    raise NotImplementedError('Faye::Authorize#initialize_authorizations')
  end
end
