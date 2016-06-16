class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :score
      t.references :votable, polymorphic: true
      t.references :user, foreign_key: true

      t.timestamps null: false
    end

    add_index :votes, [:user_id, :votable_id, :votable_type], unique:true
  end
end
