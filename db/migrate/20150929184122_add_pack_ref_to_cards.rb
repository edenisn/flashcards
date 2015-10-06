class AddPackRefToCards < ActiveRecord::Migration
  def change
    add_reference :cards, :pack, index: true, foreign_key: true
  end
end
