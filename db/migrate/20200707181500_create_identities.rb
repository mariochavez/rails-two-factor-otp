class CreateIdentities < ActiveRecord::Migration[6.0]
  def change
    create_table :identities do |t|
      t.string :email
      t.string :password_hash
      t.string :password_digest

      t.timestamps
    end
  end
end
