class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.boolean :is_admin
      t.string :allowed_cameras

      t.timestamps
    end
  end
end
