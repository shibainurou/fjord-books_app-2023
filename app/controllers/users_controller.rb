# frozen_string_literal: true

class UsersController < ApplicationController
  before_action do
    I18n.locale = :ja # Or whatever logic you use to choose.
  end

  def index
    @users = User.order(:id).page(params[:page]).per(1)
  end

  def show
    @user = User.find(params[:id])
  end
end
