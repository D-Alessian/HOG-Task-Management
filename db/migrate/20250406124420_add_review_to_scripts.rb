class AddReviewToScripts < ActiveRecord::Migration[7.1]
  def change
    add_column :scripts, :review, :boolean
  end
end
