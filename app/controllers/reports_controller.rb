# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    ActiveRecord::Base.transaction do
      if @report.save
        delete_insert_mentions
        redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      if @report.update(report_params)
        delete_insert_mentions
        redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def delete_insert_mentions
    @report.mentioning_reports.clear

    report_url_regex = %r{#{request.base_url}/reports/([0-9]+)(?=\s|$)}
    mention_report_ids = @report.content.scan(report_url_regex).flatten.uniq
    mention_report_ids.each do |mention_report_id|
      mention_report = Report.find_by(id: mention_report_id)
      Mention.create!(mentioning_report: @report, mentioned_report: mention_report) if mention_report.present?
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end
end
