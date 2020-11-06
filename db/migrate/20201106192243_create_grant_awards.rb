class CreateGrantAwards < ActiveRecord::Migration[6.0]
  def change
    create_table :grant_awards do |t|
      t.references :grant_recipient, null: false, foreign_key: true
      t.references :grant_filing, null: false, foreign_key: true
      t.float :amount
      t.string :purpose

      t.timestamps
    end
  end
end
