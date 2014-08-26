class CreateRaspis < ActiveRecord::Migration
  def change
    create_table :raspis do |t|
      t.string :label
      t.string :ipv4
      t.references :user, index: true

      t.timestamps
    end
  end
end
