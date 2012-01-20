class AddJobIdToPorets < ActiveRecord::Migration
  def change
    add_column :reports, :job_id, :integer
  end
end
