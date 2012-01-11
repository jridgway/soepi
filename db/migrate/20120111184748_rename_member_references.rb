class RenameMemberReferences < ActiveRecord::Migration
  def up
    rename_table :members_member_statuses, :member_statuses_members
  end

  def down
    rename_table :member_statuses_members, :members_member_statuses
  end
end
