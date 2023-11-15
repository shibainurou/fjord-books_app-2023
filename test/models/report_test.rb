# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'save content without mention' do
    report = Report.new(title: 'test', content: 'test')
    report.save
    assert_equal report.mentioning_reports.count, 0
    assert_equal reports(:one).mentioned_reports.count, 0
    assert_equal reports(:two).mentioned_reports.count, 0
  end

  test 'save content with mention' do
    assert_equal reports(:one).mentioned_reports.count, 0

    user = users(:two)
    report_id = reports(:one).id.to_s
    report = user.reports.new(title: 'test', content: "http://localhost:3000/reports/#{report_id}")
    report.save
    assert_equal report.mentioning_reports.count, 1
    assert_equal report.mentioning_reports.first, reports(:one)
    assert_equal reports(:one).mentioned_reports.count, 1
    assert_equal reports(:one).mentioned_reports.first, report
    assert_equal reports(:two).mentioned_reports.count, 0
  end

  test 'update content without mention' do
    report = Report.new(title: 'test', content: 'test')
    report.save
    report.update(title: report.title, content: 'test2')
    assert_equal report.mentioning_reports.count, 0
    assert_equal reports(:one).mentioned_reports.count, 0
    assert_equal reports(:two).mentioned_reports.count, 0
  end

  test 'update content with mention' do
    assert_equal reports(:one).mentioned_reports.count, 0

    report = reports(:two)
    report_id = reports(:one).id.to_s
    report.update(title: report.title, content: "http://localhost:3000/reports/#{report_id}")
    assert_equal report.mentioning_reports.count, 1
    assert_equal report.mentioning_reports.first, reports(:one)
    assert_equal reports(:one).mentioned_reports.count, 1
    assert_equal reports(:one).mentioned_reports.first, report
    assert_equal reports(:two).mentioned_reports.count, 0
  end
end
