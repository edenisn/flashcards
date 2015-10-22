class AddNumberRepetitionsToCards < ActiveRecord::Migration
  def change
    add_column :cards, :number_repetitions, :integer, default: 0
  end
end
