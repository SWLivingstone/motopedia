class AddSubIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :sub_id, :string
  end
end
