class RemoveUserIdFromCards < ActiveRecord::Migration
  def change
    remove_column :cards, :user_id, :integer, null: false, index: true
  end
end
