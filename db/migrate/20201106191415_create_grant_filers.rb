class CreateGrantFilers < ActiveRecord::Migration[6.0]
  def change
    create_table :grant_filers do |t|
      t.string :ein
      t.string :name
      t.string :line_1
      t.string :line_2
      t.string :city
      t.string :state
      t.string :zip_code

      t.timestamps
    end
    add_index :grant_filers, :ein, unique: true
  end
end
