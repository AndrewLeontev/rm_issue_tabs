class RmIssueTimeStatistic < ActiveRecord::Base
  include Redmine::SafeAttributes
  belongs_to :user, foreign_key: :user_id
  belongs_to :issue
  belongs_to :status, class_name: 'IssueStatus', foreign_key: :status_id

  safe_attributes 'id', 'created_at', 'updated_at', {unsafe: true}
end