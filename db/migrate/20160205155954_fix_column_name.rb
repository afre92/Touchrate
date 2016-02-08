class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :users, :uid, :app_key
  end
end
