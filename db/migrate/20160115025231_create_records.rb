class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :sender
      t.string :time
      t.string :keyword
      t.string :text
      t.integer :commentid
      t.integer :mediaid

      t.timestamps
    end
  end
end
