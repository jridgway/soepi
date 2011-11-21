class CreateMemberCreditTransactions < ActiveRecord::Migration
  def change
    create_table :member_credit_transactions do |t|
      t.integer :credits
      t.integer :member_id, :null => false
      t.string :reason, :null => false

      t.timestamps
    end
  end
end
