namespace :redmine do
  namespace :rm_issue_tabs do
    task fill_rm_issue_time_statuses: :environment do
      RmIssueTimeStatistic.delete_all
      jds = JournalDetail.joins(:journal).preload(journal: :journalized)
              .where("#{Journal.table_name}.journalized_type = 'Issue' and #{JournalDetail.table_name}.prop_key = ?", 'status_id')
              .order("#{Journal.table_name}.journalized_id, #{Journal.table_name}.created_on")

      old_jd_time = nil
      jds.each do |jd|
        status = jd.old_value
        user = jd.journal.user_id

        date = jd.journal.created_on
        time = Time.now.utc - date
        st = RmIssueTimeStatistic.where(issue_id: jd.journal.journalized_id).order("#{RmIssueTimeStatistic.table_name}.id DESC").first
        time_st = old_jd_time - date if (st)
        old_jd_time = date

        ts = RmIssueTimeStatistic.create(issue_id: jd.journal.journalized_id, status_id: status, user_id: user, time: time - (time_st || 0))
        puts "#{ts} created" if ts
      end
    end
  end
end