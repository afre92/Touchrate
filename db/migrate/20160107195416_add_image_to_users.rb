class AddImageToUsers < ActiveRecord::Migration
  # def up
  #   add_attachment :users, :image
  # end
  #
  # def down
  #   remove_attachment :users, :image
  # end
  def change
    add_column :users, :image, :string
  end
end
