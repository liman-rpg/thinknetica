class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user
      t.integer :subscriptable_id
      t.string :subscriptable_type
      t.timestamps null: false
    end
    add_foreign_key :subscriptions, :users
    add_index :subscriptions, [:user_id, :subscriptable_id, :subscriptable_type], unique: true, name: 'subscriptable_index'
  end
end
