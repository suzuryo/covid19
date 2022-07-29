# frozen_string_literal: true

require 'spec_helper'

def has_monitoring_confirmed_cases_number_card
  # h3
  expect(find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq '新規陽性者数の7日間移動平均'
  d = find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3 > a')[:href]
  expect(URI.parse(d).path).to eq '/cards/monitoring-number-of-confirmed-cases/'

  # 日付
  d = Date.parse(POSITIVE_RATE_JSON['data'].last['diagnosed_date']).strftime('%-m月%-d日')
  expect(find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div > div > small').text).to match "^#{d} の数値"

  # 新規陽性者数の7日間移動平均
  d = number_to_delimited(POSITIVE_RATE_JSON['data'].last['weekly_average_positive_count'])
  expect(find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div:nth-child(1) > div > span > strong').text).to eq d.to_s

  # データを表示ボタンの文言
  expect(find('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').text).to eq 'データを表示'

  # データを表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  find('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

  # テーブルの上から2番目の値を確認(日付)
  d = Date.parse(POSITIVE_RATE_JSON['data'][-2]['diagnosed_date']).strftime('%-m月%-d日')
  expect(find('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(2) > th > time').text).to eq d.to_s

  d = Date.parse(POSITIVE_RATE_JSON['data'][-2]['diagnosed_date']).strftime('%Y-%m-%d')
  expect(find('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(2) > th > time')['datetime']).to eq d.to_s

  # テーブルの上から2番目の値を確認(陽性者数)
  d = number_to_delimited(POSITIVE_RATE_JSON['data'][-2]['positive_count'].to_i)
  expect(find('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(2) > td:nth-child(2)').text).to eq d.to_s

  # テーブルの上から2番目の値を確認(7日間移動平均)
  d = number_to_delimited((POSITIVE_RATE_JSON['data'][-8..-2].reduce(0) { |sum, n| sum + n['positive_count'].to_i } / 7.0).round(1))
  expect(find('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(2) > td:nth-child(3)').text).to eq d.to_s

  # データを表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  find('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

  # 注釈を表示ボタンの文言
  expect(find('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq '注釈'

  # 注釈を表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content')
  sleep 0.5
  find('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content')

  # 注釈の中身をチェック
  expect(find('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(1)').text).to eq JA_JSON['Common']['検査結果の判明日を基準とする']
  JA_JSON['MonitoringConfirmedCasesNumberCard']['a'].each_with_index do |item, i|
    expect(find("#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(#{2 + i})").text).to eq item
  end
  expect(find('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(3)').text).to eq JA_JSON['Common']['7MA']

  # 注釈を表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content')

  # データを表示と注釈を表示の両方を開く
  expect(page).not_to have_selector('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  expect(page).not_to have_selector('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel--active')
  find('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  sleep 1
  find('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  expect(page).to have_selector('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel--active')
end
