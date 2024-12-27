class CreateDeviceDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :device_details do |t|
      t.string :authentication_token
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
