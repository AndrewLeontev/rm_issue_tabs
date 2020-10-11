module RmIssueTabs::Redmine
  module IssueControllerExt
    def self.included(base)
      base.class_eval do
        include RmIssueTimeStatisticsHelper
        helper :rm_issue_time_statistics
      end
    end
  end
end