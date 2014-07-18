class CreateFish < ActiveRecord::Migration
  def up
    create_table :fish do |t|
      t.string :name
      t.string :url
      t.integer :user_id
    end
  end

  def down
    drop_table :fish
  end
end
