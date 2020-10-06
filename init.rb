Redmine::Plugin.register :rm_issue_tabs do
  name 'Rm Issue Tabs plugin'
  author 'Andrey Leontev'
  description 'Adds a tab for the total time spent by the task in each of the statuses.'
  version '0.0.1'

  requires_redmine :version_or_higher => '4.1.1'

  project_module :rm_issue_tabs do
    permission :show_rm_issue_tabs, :rm_issue_tabs => [:show]
  end
end