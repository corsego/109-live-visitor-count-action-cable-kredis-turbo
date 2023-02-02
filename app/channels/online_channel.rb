class OnlineChannel < Turbo::StreamsChannel
  def subscribed
    super
    visitors_online = Kredis.unique_list "visitors_online"
    visitors_online << session_user
    update_visitors_count(visitors_online)
  end

  def unsubscribed
    visitors_online = Kredis.unique_list "visitors_online"
    visitors_online.remove session_user
    update_visitors_count(visitors_online)
  end

  private

  def update_visitors_count(visitors_online)
    Turbo::StreamsChannel.broadcast_update_to(
      verified_stream_name_from_params,
      target: 'online-counter',
      html: visitors_online.elements.count
    )
  end
end