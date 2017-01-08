task :send_reminders => :environment do
  User.notify_pending_cards
end
