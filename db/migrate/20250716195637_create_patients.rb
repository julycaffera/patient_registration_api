class CreatePatients < ActiveRecord::Migration[7.2]
  def change
    create_table :patients do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :address, null: false
      t.string :phone, null: false

      t.timestamps
    end
  end
end
