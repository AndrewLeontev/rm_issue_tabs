module RmIssueTimeStatisticsHelper
  def hourize(seconds, options={})
    return 'x' if (seconds.nil?)
    result = []
    if (seconds == 0)
      result << wrap_value(0, I18n.t('rm_time_statistics.label_hours'))
    else
      seconds = seconds.to_i
      days = 0
      if (options[:without_days].nil? || !options[:without_days])
        days = (seconds / 86400).to_i
        seconds = seconds - (days * 86400)
      end
      hours = (seconds / 3600).to_i
      seconds = seconds - (hours * 3600)
      minutes = (seconds / 60).to_i
      seconds = seconds - (minutes * 60)

      result << wrap_value(days, I18n.t('rm_time_statistics.label_days')) if (days > 0)
      result << wrap_value(hours, I18n.t('rm_time_statistics.label_hours')) if (hours > 0)
      result << wrap_value(minutes, I18n.t('rm_time_statistics.label_minutes')) if (minutes > 0)
      result << wrap_value(seconds, I18n.t('rm_time_statistics.label_seconds')) if (seconds > 0 && days <= 0 && hours <= 0)
    end

    result.join(' ').html_safe
  end

  def wrap_value(value, unit)
    "<span class='cp_value_normal'>#{value}</span><span class='cp_unit_def'>#{unit}</span>".html_safe
  end
end
