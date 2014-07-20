class CreateFish < ActiveRecord::Migration
  def up
    create_table :fish do |t|
      t.string :white_player
      t.string :black_player
      t.string :winner
    end
  end

  def down
    drop_table :matches
  end
end