class LimitPhoneNumber < ActiveRecord::Migration[6.1]
  def up
    User.find_each do |user|
    user.phone_number.nil? ? user.update(phone_number: '11111111111') : user.update(phone_number: user.phone_number.slice(0..14))
  end
    change_column :users, :phone_number, :string, limit: 15, default:'11111111111', null: false
  end

  def down
    change_column :users, :phone_number, :string, limit:15
  end
end
