# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable?' do
    report = reports(:one)
    assert_equal true, report.editable?(report.user)

    report1 = reports(:one)
    report2 = reports(:two)
    assert_equal false, report2.editable?(report1.user)
  end

  test 'returns the date part of created_at' do
    report = reports(:one)
    today = Time.zone.today
    assert_equal today.to_date, report.created_on
  end

  test 'save content without mention' do
    report = Report.new(title: 'test', content: 'test')
    report.save
    assert_equal 0, report.mentioning_reports.count
    assert_equal 0, reports(:one).mentioned_reports.count
    assert_equal 0, reports(:two).mentioned_reports.count
  end

  test 'save content with mention' do
    assert_equal reports(:one).mentioned_reports.count, 0

    user = users(:two)
    report_id = reports(:one).id.to_s
    report = user.reports.new(title: 'test', content: "http://localhost:3000/reports/#{report_id}")
    report.save
    assert_equal 1, report.mentioning_reports.count
    assert_equal reports(:one), report.mentioning_reports.first
    assert_equal 1, reports(:one).mentioned_reports.count
    assert_equal report, reports(:one).mentioned_reports.first
    assert_equal 0, reports(:two).mentioned_reports.count
  end

  test 'update content without mention' do
    report = Report.new(title: 'test', content: 'test')
    report.save
    report.update(title: report.title, content: 'test2')
    assert_equal 0, report.mentioning_reports.count
    assert_equal 0, reports(:one).mentioned_reports.count
    assert_equal 0, reports(:two).mentioned_reports.count
  end

  test 'update content with mention' do
    assert_equal reports(:one).mentioned_reports.count, 0

    report = reports(:two)
    report_id = reports(:one).id.to_s
    report.update(title: report.title, content: "http://localhost:3000/reports/#{report_id}")
    assert_equal 1, report.mentioning_reports.count
    assert_equal reports(:one), report.mentioning_reports.first
    assert_equal 1, reports(:one).mentioned_reports.count
    assert_equal report, reports(:one).mentioned_reports.first
    assert_equal 0, reports(:two).mentioned_reports.count
  end
end
