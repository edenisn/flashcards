class SorceryCore < ActiveRecord::Migration
  def change
    change_column_null :users, :email, false
    remove_column :users, :password
    add_column :users, :crypted_password, :string
    add_column :users, :salt, :string

    add_index :users, :email, unique: true
  end
end