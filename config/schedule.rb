every 1.minutes do
  runner 'User.notify_pending_cards', environment: 'development'
end
