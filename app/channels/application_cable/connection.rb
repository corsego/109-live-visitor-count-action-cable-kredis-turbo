module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :session_user

    def session_user
      self.session_user = request.session.id
    end
  end
end
