class AddUserRefToPacks < ActiveRecord::Migration
  def change
    add_reference :packs, :user, index: true, foreign_key: true
  end
end
