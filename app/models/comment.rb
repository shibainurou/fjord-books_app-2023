# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user, foreign_key: :user_id, inverse_of: :comments
end
