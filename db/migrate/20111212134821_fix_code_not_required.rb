class FixCodeNotRequired < ActiveRecord::Migration
  def up
    change_column :r_scripts, :code, :text, :null => true
  end

  def down
    change_column :r_scripts, :code, :text, :null => false
  end
end
