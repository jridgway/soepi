class DropChartsAndMore < ActiveRecord::Migration
  def up
    drop_table :charts
    add_column :members, :credits, :integer, :default => 10
    add_column :members, :ec2_instance_id, :string
  end

  def down
    create_table "charts", :force => true do |t|
      t.string   "title"
      t.text     "description"
      t.integer  "member_id"
      t.boolean  "anonymous"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "slug"
    end
  
    add_index "charts", ["id"], :name => "index_charts_on_id", :unique => true
    add_index "charts", ["member_id"], :name => "index_charts_on_member_id"
    add_index "charts", ["slug"], :name => "index_charts_on_slug"
    
    remove_column :members, :credits
    remove_column :members, :ec2_instance_id
  end
end
