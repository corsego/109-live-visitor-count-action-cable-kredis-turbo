class RoomChannel < Turbo::StreamsChannel
  def subscribed
    super
    room_visitors = Kredis.unique_list "room_visitors"
    room_visitors << session_user
    target = "room-#{params[:room_id]}-counter"
    update_visitors_count(room_visitors, target)
  end

  def unsubscribed
    room_visitors = Kredis.unique_list "room_visitors"
    room_visitors.remove session_user
    target = "room-#{params[:room_id]}-counter"
    update_visitors_count(room_visitors, target)
  end

  private

  def update_visitors_count(room_visitors, target)
    Turbo::StreamsChannel.broadcast_update_to(
      verified_stream_name_from_params,
      target:,
      html: room_visitors.elements.count
    )
  end
end
