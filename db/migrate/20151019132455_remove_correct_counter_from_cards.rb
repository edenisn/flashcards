class RemoveCorrectCounterFromCards < ActiveRecord::Migration
  def change
    remove_column :cards, :correct_counter, :integer
  end
end
