class RmIssueTabsController < ApplicationController
  before_action :require_login

  include RmIssueTimeStatisticsHelper
  helper :rm_issue_time_statistics

  def statuses_spent_time
    @issue = Issue.where(id: params[:id]).first
  end
end