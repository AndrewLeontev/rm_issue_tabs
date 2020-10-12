namespace :redmine do
  namespace :rm_issue_tabs do
    task fill_rm_issue_time_statuses: :environment do
      RmIssueTimeStatistic.delete_all
      jds = JournalDetail.joins(:journal).preload(journal: :journalized)
              .where("#{Journal.table_name}.journalized_type = 'Issue' and #{JournalDetail.table_name}.prop_key = ?", 'status_id')
              .order("#{Journal.table_name}.journalized_id, #{JournalDetail.table_name}.old_value, #{Journal.table_name}.created_on")
      hash = Hash.new({})
      jds.each do |jd|
        hash[jd.journal.journalized_id] = { old_value: jd.old_value, created_on: jd.journal.created_on } unless hash[jd.journal.journalized_id].present?
      end

      issues = Issue.joins("LEFT JOIN #{Journal.table_name} j ON j.journalized_id = #{Issue.table_name}.id and j.journalized_type = 'Issue'
                          LEFT JOIN #{JournalDetail.table_name} jd ON jd.journal_id = j.id  and jd.prop_key = 'status_id'")
                    .preload(journals: :details)
                    .select("#{Issue.table_name}.*, jd.old_value old_status, j.created_on j_created, j.user_id j_user_id")

      old_jd_time = nil

      issues.each do |i|
        if i.old_status
          status = i.old_status
          user = i.j_user_id
          date = i.j_created.to_datetime.utc
        else
          status = hash[i.id].present? ? hash[i.id][:old_value] : i.status_id
          user = i.author_id
          date = i.created_on.utc
        end

        st = RmIssueTimeStatistic.where(issue_id: i.id).order("#{RmIssueTimeStatistic.table_name}.id DESC").first
        if st && i.old_status.present?
          time = date - old_jd_time
        else
          time = hash[i.id].present? ? hash[i.id][:created_on].to_datetime.utc - date : Time.now.utc - date
        end
        old_jd_time = date

        ts = RmIssueTimeStatistic.create(issue_id: i.id, status_id: status, user_id: user, time: time)
        puts "#{ts} created for issue ##{i.id} - #{status} - #{date} - #{old_jd_time}" if ts
      end
    end
  end
end