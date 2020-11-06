class CreateGrantRecipients < ActiveRecord::Migration[6.0]
  def change
    create_table :grant_recipients do |t|
      t.string :ein
      t.string :name
      t.string :line_1
      t.string :line_2
      t.string :city
      t.string :state
      t.string :zip_code

      t.timestamps
    end
    add_index :grant_recipients, :ein, unique: true
  end
end
