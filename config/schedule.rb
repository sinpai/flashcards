every 1.day, at: '8:30 am' do
  runner 'User.notify_pending_cards', environment: 'development'
end
