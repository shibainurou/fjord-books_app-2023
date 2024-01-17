# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'returns name when name exsists' do
    user = users(:one)
    assert_equal 'test1', user.name_or_email
  end

  test 'returns email when name not exsists' do
    user = users(:two)
    assert_equal 'test2@foo.co.jp', user.name_or_email
  end
end
