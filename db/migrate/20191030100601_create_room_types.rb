class CreateRoomTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :room_types do |t|
      t.integer :location_id
      t.integer :room_type
      t.float :price_per_night
      t.integer :guests_amount

      t.timestamps
    end

    execute 'create index location_id_idx on room_types (location_id);'
  end
end
