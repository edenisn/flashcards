class RemoveWrongCounterFromCards < ActiveRecord::Migration
  def change
    remove_column :cards, :wrong_counter, :integer
  end
end
