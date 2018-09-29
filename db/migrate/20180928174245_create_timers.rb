class CreateTimers < ActiveRecord::Migration[5.2]
  def change
    create_table :timers do |t|
      t.references :user, foreign_key: true
      t.integer :seconds
      t.datetime :start_at
      t.datetime :stop_at

      t.timestamps
    end
  end
end
