class CreateInitiatives < ActiveRecord::Migration[7.0]
  def change
    create_table :initiatives do |t|
      t.string :name,                 null: false
      t.string :category,             null: false
      t.datetime :event_date
      t.integer :participants_number, null: false, default: 0

      t.timestamps
    end
  end
end
