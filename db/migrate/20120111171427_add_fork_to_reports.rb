class AddForkToReports < ActiveRecord::Migration
  def change
    add_column :reports, :forked_from_id, :integer
  end
end
