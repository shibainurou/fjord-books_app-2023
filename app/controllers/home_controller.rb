# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to books_path
  end
end
