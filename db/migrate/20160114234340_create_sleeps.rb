class CreateSleeps < ActiveRecord::Migration
  def change
    create_table :sleeps do |t|
      t.integer :period
      t.timestamps
    end
    Sleep.create period: 20
  end 
end
