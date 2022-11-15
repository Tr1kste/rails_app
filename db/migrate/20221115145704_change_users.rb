class ChangeUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :first_name, false
    add_column :users, :email, :string, index: { unique: true }
  end
end
