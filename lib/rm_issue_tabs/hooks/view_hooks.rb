module RmIssueTabs::Hooks
  class ViewHoks < Redmine::Hook::ViewListener
    render_on :view_issues_show_details_bottom, partial: 'hooks/rm_issue_tabs/view_issues_show_details_bottom'
    render_on :view_layouts_base_html_head, partial: 'hooks/rm_issue_tabs/view_layouts_base_html_head'
  end
end