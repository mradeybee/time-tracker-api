class CreateTokenBlacklists < ActiveRecord::Migration[5.2]
  def change
    create_table :token_blacklists do |t|
      t.string :token

      t.timestamps
    end
  end
end
