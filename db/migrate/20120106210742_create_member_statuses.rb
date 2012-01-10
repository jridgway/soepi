class CreateMemberStatuses < ActiveRecord::Migration
  def change
    create_table :member_statuses do |t|
      t.text :body
      t.integer :repost_id
      t.integer :member_id

      t.timestamps
    end

    create_table :members_member_statuses, :id => false, :force => true do |t|
      t.integer "member_id"
      t.integer "member_status_id"
    end
  end
end
