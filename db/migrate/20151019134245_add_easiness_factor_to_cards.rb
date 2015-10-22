class AddEasinessFactorToCards < ActiveRecord::Migration
  def change
    add_column :cards, :easiness_factor, :float, default: 2.5
  end
end
