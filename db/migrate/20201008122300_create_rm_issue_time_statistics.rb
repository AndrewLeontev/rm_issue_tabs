class CreateRmIssueTimeStatistics < ActiveRecord::Migration[5.2]
  def change
    create_table :rm_issue_time_statistics do |t|
      t.integer :issue_id, null: false
      t.integer :status_id, null: false
      t.integer :user_id, null: true
      t.integer :time, null: false, default: 0
      t.timestamps
    end

    add_index :rm_issue_time_statistics, [:issue_id]
    add_index :rm_issue_time_statistics, [:status_id]
    add_index :rm_issue_time_statistics, [:user_id]
    add_index :rm_issue_time_statistics, [:issue_id, :status_id, :user_id], name: 'index_rm_issue_time_statistics_isu'
  end
end