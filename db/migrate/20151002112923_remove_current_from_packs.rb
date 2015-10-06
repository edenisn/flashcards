class RemoveCurrentFromPacks < ActiveRecord::Migration
  def change
    remove_column :packs, :current, :true
  end
end
