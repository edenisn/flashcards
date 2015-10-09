class AddCorrectCounterToCards < ActiveRecord::Migration
  def change
    add_column :cards, :correct_counter, :integer, default: 0
  end
end
