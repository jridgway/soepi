class FixReports < ActiveRecord::Migration
  def up
    add_column :reports, :r_script_id, :integer
    add_column :reports, :code, :text
    add_column :reports, :results, :text
    change_column :reports, :state, :string, :default => 'pending'
    change_column :reports, :body, :text, :null => true
  end

  def down
    remove_column :reports, :r_script_id
    remove_column :reports, :code
    remove_column :reports, :results
    change_column :reports, :body, :text, :null => false
  end
end
