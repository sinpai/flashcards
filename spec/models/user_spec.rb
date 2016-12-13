require 'rails_helper'

RSpec.describe User, :type => :model do
  it 'is valid with email and password' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'is invalid without specified email' do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is invalid without password" do
    user = build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it "prevents from saving user with the same email" do
    create(:user,
           email: 'test@test.com',
           password: 'qweasd'
          )
    user = build(:user,
                 email: 'test@test.com',
                 password: 'qweasd123'
                )
    user.save
    expect(user.errors[:email]).to include('has already been taken')
  end

  it "is invalid with password less than 6 chars" do
    user = build(:user, password: '123')
    user.valid?
    expect(user.errors[:password]).to include(/is too short/)
  end
end
