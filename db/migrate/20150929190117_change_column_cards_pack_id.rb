class ChangeColumnCardsPackId < ActiveRecord::Migration
  def change
    change_column_null :cards, :pack_id, false
  end
end
