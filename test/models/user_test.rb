# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'returns name when name exsists' do
    user = users(:one)
    assert(user.name_or_email == 'test1')
  end

  test 'returns email when name not exsists' do
    user = users(:two)
    assert(user.name_or_email == 'test2@foo.co.jp')
  end
end
