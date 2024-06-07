class ChangeNameAndLocationColumns < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :name, :jsonb
    change_column :users, :location, :jsonb
  end
end
