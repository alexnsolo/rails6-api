class CreateGrantFilers < ActiveRecord::Migration[6.0]
  def change
    create_table :grant_filers do |t|
      t.string :ein
      t.string :name
      t.references :address

      t.timestamps
    end
    add_index :grant_filers, :ein, unique: true
  end
end
