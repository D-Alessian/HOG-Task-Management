class ChangeUserIdNullOnScripts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :scripts, :user_id, true
  end
end
