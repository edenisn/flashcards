class AddWrongCounterToCards < ActiveRecord::Migration
  def change
    add_column :cards, :wrong_counter, :integer, default: 0
  end
end
