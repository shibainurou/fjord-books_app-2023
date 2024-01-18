# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @report = reports(:one)
  end

  test 'ログイン後に日報を作成する' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'テストタイトル'
    fill_in '内容', with: 'テストコンテンツ'
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text 'テストタイトル'
    assert_text 'テストコンテンツ'

    click_on '日報の一覧に戻る'
  end

  test '日報を編集する' do
    visit report_url(@report)
    click_on 'この日報を編集'

    fill_in 'タイトル', with: 'テストタイトル編集'
    fill_in '内容', with: 'テストコンテンツ編集'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text 'テストタイトル編集'
    assert_text 'テストコンテンツ編集'

    click_on '日報の一覧に戻る'
  end

  test '日報を削除する' do
    visit report_url(@report)
    click_on 'この日報を削除'

    assert_text '日報が削除されました。'
    assert_no_text 'テストタイトル編集'
    assert_no_text 'テストコンテンツ編集'
  end
end
