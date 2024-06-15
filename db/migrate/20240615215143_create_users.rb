class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :email
      t.json :address, default: {}
      t.string :phone
      t.string :website
      t.json :company, default: {}
      t.string :photo_url

      t.timestamps
    end
  end
end
