class CreateCommons < ActiveRecord::Migration
  def self.up
    create_table :commons do |t|
      t.string :english
      t.string :danish
      t.string :swedish
      t.string :norwegian
      t.string :hungarian

      t.timestamps
    end
  end

  def self.down
    drop_table :commons
  end
end
