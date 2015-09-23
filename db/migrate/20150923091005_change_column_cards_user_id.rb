class ChangeColumnCardsUserId < ActiveRecord::Migration
  def change
    change_column_null :cards, :user_id, false
  end
end
