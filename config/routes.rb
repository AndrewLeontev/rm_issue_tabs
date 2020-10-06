resources :polls do
  get 'issues/:id/statuses_spent_time', controller: :rm_issue_tabs, action: :statuses_spent_time
end