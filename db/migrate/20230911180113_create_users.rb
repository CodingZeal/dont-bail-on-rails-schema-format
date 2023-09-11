class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, index: { unique: true }, null: false
      t.string :super_secret, null: false
      t.string :special_field
      t.timestamps
    end
  end
end
