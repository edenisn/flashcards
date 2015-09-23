class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.belongs_to :user, index:true
      t.string :original_text
      t.string :translated_text
      t.date :review_date

      t.timestamps null: false
    end
  end
end
