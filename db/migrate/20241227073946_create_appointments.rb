class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.references :doctor, foreign_key: { to_table: :users }
      t.references :patient, foreign_key: { to_table: :users }
      t.references :time_slot, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.date :for_date
      t.string :status, default: 'scheduled'
    
      t.timestamps
    end
  end
end
