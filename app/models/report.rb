# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentioning_reports_relationship, class_name: 'Mention', foreign_key: 'mentioning_report_id', inverse_of: :mentioning_report, dependent: :destroy
  has_many :mentioning_reports, through: :mentioning_reports_relationship, source: :mentioned_report
  has_many :mentioned_reports_relationship, class_name: 'Mention', foreign_key: 'mentioned_report_id', inverse_of: :mentioned_report, dependent: :destroy
  has_many :mentioned_reports, through: :mentioned_reports_relationship, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def update_mentions(base_url)
    mentioning_reports.clear

    report_url_regex = %r{#{base_url}/reports/([0-9]+)(?=\s|$)}
    mention_report_ids = content.scan(report_url_regex).flatten.uniq
    mention_reports = Report.where(id: mention_report_ids)
    mention_reports.each do |mention_report|
      Mention.create!(mentioning_report: self, mentioned_report: mention_report) if mention_report.present?
    end
  end

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
