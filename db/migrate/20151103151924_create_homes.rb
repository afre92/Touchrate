class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
