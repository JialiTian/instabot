class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.text :text
      t.date :createTime
      t.date :lastUpdate
      t.timestamps
    end
  end
end
