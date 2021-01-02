class CreateTitles < ActiveRecord::Migration
  def self.up
    create_table :titles do |t|
      t.string :english
      t.string :danish
      t.string :swedish
      t.string :norwegian
      t.string :hungarian

      t.timestamps
    end
  end

  def self.down
    drop_table :titles
  end
end
