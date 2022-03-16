# frozen_string_literal: true

require 'spec_helper'

def has_tested_number_card(lang:, lang_json:)
  # h3
  expect(find('#TestedNumberCard > div > div > div.DataView-Header > div > div > h3').text).to eq lang_json['TestedNumberCard']['title']
  d = find('#TestedNumberCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  lang_prefix = lang == :ja ? '' : "/#{lang}"
  expect(URI.parse(d).path).to eq "#{lang_prefix}/cards/number-of-tested/"

  # 日付
  d2_1 = POSITIVE_RATE_JSON['data'][-1]['pcr_positive_count'] + POSITIVE_RATE_JSON['data'][-1]['antigen_positive_count'] + POSITIVE_RATE_JSON['data'][-1]['pcr_negative_count'] + POSITIVE_RATE_JSON['data'][-1]['antigen_negative_count']
  d2_2 = POSITIVE_RATE_JSON['data'][-2]['pcr_positive_count'] + POSITIVE_RATE_JSON['data'][-2]['antigen_positive_count'] + POSITIVE_RATE_JSON['data'][-2]['pcr_negative_count'] + POSITIVE_RATE_JSON['data'][-2]['antigen_negative_count']
  d2_diff = d2_1 - d2_2
  d2 = if d2_diff > 0
         "+#{d2_diff}"
       elsif d2_diff < 0
         "-#{d2_diff}"
       else
         d2_diff
       end
  if lang == :ja
    d = Date.parse(POSITIVE_RATE_JSON['data'].last['diagnosed_date']).strftime('%-m月%-d日')
    expect(find('#TestedNumberCard > div > div > div.DataView-Header > div > div > div > small').text).to eq "#{d} 日別値（前日比: #{d2} 件）"
  elsif lang == :en
    d = Date.parse(POSITIVE_RATE_JSON['data'].last['diagnosed_date']).strftime('%b %-d')
    expect(find('#TestedNumberCard > div > div > div.DataView-Header > div > div > div > small').text).to eq "#{d} as a day（Day-over-day change: #{d2} cases）"
  end

  # 検査実施件数
  d = number_to_delimited(POSITIVE_RATE_JSON['data'].last['pcr_positive_count'].to_i + POSITIVE_RATE_JSON['data'].last['antigen_positive_count'].to_i + POSITIVE_RATE_JSON['data'].last['pcr_negative_count'].to_i + POSITIVE_RATE_JSON['data'].last['antigen_negative_count'].to_i)
  expect(find('#TestedNumberCard > div > div > div.DataView-Header > div > div > div > span > strong').text).to eq d.to_s

  # データを表示ボタンの文言
  expect(find('#TestedNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').text).to eq lang_json['Common']['データを表示']

  # データを表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  find('#TestedNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

  # テーブルの上から2行目をチェックする(日付)
  if lang == :ja
    d = Date.parse(POSITIVE_RATE_JSON['data'].last['diagnosed_date']).strftime('%-m月%-d日')
  elsif lang == :en
    d = Date.parse(POSITIVE_RATE_JSON['data'].last['diagnosed_date']).strftime('%b %-d')
  end
  expect(find('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > th > time').text).to eq d.to_s

  d = Date.parse(POSITIVE_RATE_JSON['data'].last['diagnosed_date']).strftime('%Y-%m-%d')
  expect(find('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > th > time')['datetime']).to eq d.to_s

  # テーブルの上から2行目をチェックする(検査実施件数・日別)
  d = number_to_delimited(POSITIVE_RATE_JSON['data'].last['pcr_positive_count'].to_i + POSITIVE_RATE_JSON['data'].last['pcr_negative_count'].to_i + POSITIVE_RATE_JSON['data'].last['antigen_positive_count'].to_i + POSITIVE_RATE_JSON['data'].last['antigen_negative_count'].to_i)
  expect(find('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(2)').text).to eq d.to_s

  # テーブルの上から2行目をチェックする(検査実施件数・累計)
  d = number_to_delimited(POSITIVE_RATE_JSON['data'].reduce(0) { |sum, n| sum + n['pcr_positive_count'].to_i + n['pcr_negative_count'].to_i + n['antigen_positive_count'].to_i + n['antigen_negative_count'].to_i })
  expect(find('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq d.to_s

  # データを表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  find('#TestedNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

  # 注釈を表示ボタンの文言
  expect(find('#TestedNumberCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq lang_json['Common']['注']

  # 注釈を表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#TestedNumberCard .NotesExpansionPanel .v-expansion-panel-content')
  sleep 0.5
  find('#TestedNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#TestedNumberCard .NotesExpansionPanel .v-expansion-panel-content')

  # 注釈の中身をチェック
  lang_json['TestedNumberCard']['notes'].each_with_index do |note, i|
    expect(find("#TestedNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(#{i+1})").text).to eq note
  end

  # 注釈を表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#TestedNumberCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#TestedNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#TestedNumberCard .NotesExpansionPanel .v-expansion-panel-content')

  # データを表示と注釈を表示の両方を開く
  expect(page).not_to have_selector('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  expect(page).not_to have_selector('#TestedNumberCard .NotesExpansionPanel .v-expansion-panel--active')
  find('#TestedNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  sleep 1
  find('#TestedNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  expect(page).to have_selector('#TestedNumberCard .NotesExpansionPanel .v-expansion-panel--active')
end
