class CreateCameras < ActiveRecord::Migration
  def change
    create_table :cameras do |t|
      t.string :label
      t.string :ipv4
      t.string :username
      t.string :password

      t.timestamps
    end
  end
end
