class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :location_id
      t.integer :room_type
      t.integer :guests_amount
      t.integer :user_id
      t.string :status
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end

    execute 'create index user_id_idx on orders (user_id);'
  end
end
