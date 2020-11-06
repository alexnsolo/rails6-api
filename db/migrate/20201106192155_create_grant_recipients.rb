class CreateGrantRecipients < ActiveRecord::Migration[6.0]
  def change
    create_table :grant_recipients do |t|
      t.string :ein
      t.string :name
      t.references :address, null: false, foreign_key: true

      t.timestamps
    end
    add_index :grant_recipients, :ein, unique: true
  end
end
