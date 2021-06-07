class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :address
      t.string :email
      t.string :phone
      t.datetime :birthdate

      t.timestamps
    end

    execute 'create index email_idx on users (email);'
  end
end
