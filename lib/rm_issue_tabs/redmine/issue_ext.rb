module RmIssueTabs::Redmine
  module IssueExt
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        has_many :rm_time_statistics, class_name: 'RmIssueTimeStatistic', foreign_key: :issue_id

        scope :rm_time_statistics_aggregate, -> {
          joins("INNER JOIN
                 (
                    SELECT SUM(ts.time) as total_time,
                           ts.status_id,
                           s.name,
                           s.position,
                           ts.issue_id
                    FROM #{RmIssueTimeStatistic.table_name} ts
                         INNER JOIN issue_statuses s on s.id = ts.status_id
                    GROUP BY ts.status_id, s.name, s.position, ts.issue_id
                 ) d on d.issue_id = #{Issue.table_name}.id
                ").select('AVG(d.total_time) as avg_time,
                           SUM(case when d.total_time is not null then 1 else 0 end) as avg_count,
                           d.status_id,
                           d.name as status_name,
                           d.position
                          ')
            .group('d.status_id, d.name, d.position')
            .order('d.position')
        }

        before_save :save_time_statistics
      end
    end

    module InstanceMethods
      def rm_time_statistics_aggregate
        Issue.rm_time_statistics_aggregate.where("#{Issue.table_name}.id = ?", self.id)
      end

      def save_time_statistics
        return if (self.new_record?)
        return unless self.status_id_changed?

        status = self.status_id
        status = self.status_id_was if (self.status_id_changed? && self.status_id_was)
        user = self.assigned_to_id
        user = self.assigned_to_id_was if (self.assigned_to_id_changed? && self.assigned_to_id_was)

        date = self.created_on
        st = RmIssueTimeStatistic.where(issue_id: self.id).order("#{RmIssueTimeStatistic.table_name}.id DESC").first
        date = st.created_at if (st)

        RmIssueTimeStatistic.create(issue_id: self.id, status_id: status, user_id: user, time: Time.now.utc - date)
      end
    end
  end
end