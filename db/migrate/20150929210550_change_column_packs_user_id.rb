class ChangeColumnPacksUserId < ActiveRecord::Migration
  def change
    change_column_null :packs, :user_id, false
  end
end
