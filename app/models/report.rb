# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :created_user, class_name: "User", foreign_key: "created_user_id"
end
