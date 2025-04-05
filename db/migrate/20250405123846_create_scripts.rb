class CreateScripts < ActiveRecord::Migration[7.1]
  def change
    create_table :scripts do |t|
      t.string :name
      t.string :path
      t.boolean :assigned
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
