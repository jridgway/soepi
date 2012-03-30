class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.integer :collaborable_id
      t.string :collaborable_type
      t.integer :member_id
      t.string :key
      t.string :email
      t.boolean :active, :default => false

      t.timestamps
    end
  end
end
