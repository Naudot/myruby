class RemoveTimestampsFromPlayer < ActiveRecord::Migration[7.0]
  def change
    remove_column :players, :created_at, :string
    remove_column :players, :updated_at, :string
  end
end
