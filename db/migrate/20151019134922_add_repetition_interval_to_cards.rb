class AddRepetitionIntervalToCards < ActiveRecord::Migration
  def change
    add_column :cards, :repetition_interval, :integer, default: 0
  end
end
