class CreatePacks < ActiveRecord::Migration
  def change
    create_table :packs do |t|
      t.string :name
      t.boolean :current, default: false

      t.timestamps null: false
    end
  end
end
