class AddCompletedToScripts < ActiveRecord::Migration[7.1]
  def change
    add_column :scripts, :completed, :boolean
  end
end
