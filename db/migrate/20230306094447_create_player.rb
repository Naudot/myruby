class CreatePlayer < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.date :age
      t.integer :elo

      t.timestamps
    end
  end
end
