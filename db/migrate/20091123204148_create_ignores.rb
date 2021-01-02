class CreateIgnores < ActiveRecord::Migration
  def self.up
    create_table :ignores do |t|
      t.string :word

      t.timestamps
    end
  end

  def self.down
    drop_table :ignores
  end
end
