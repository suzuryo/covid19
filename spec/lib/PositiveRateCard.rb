# frozen_string_literal: true

require 'spec_helper'

def has_positive_rate_card(lang:, lang_json:)
  # h3
  expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq "#{lang_json['PositiveRateCard']['titles'][0]} *"
  expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(2) > h3').text).to eq lang_json['PositiveRateCard']['titles'][1]
  lang_prefix = lang == :ja ? '' : "/#{lang}"
  d = find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3 > a')[:href]
  expect(URI.parse(d).path).to eq "#{lang_prefix}/cards/positive-rate/"
  d = find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(2) > h3 > a')[:href]
  expect(URI.parse(d).path).to eq "#{lang_prefix}/cards/positive-rate/"

  # 日付
  if lang == :ja
    d = Date.parse(POSITIVE_RATE_JSON['data'].last['diagnosed_date']).strftime('%-m月%-d日')
  end
  if lang == :en
    d = Date.parse(POSITIVE_RATE_JSON['data'].last['diagnosed_date']).strftime('%b %-d')
  end
  expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(1) > div > small').text).to match lang_json['{date} の数値'].gsub('{date}', d)
  expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(2) > div > small').text).to match lang_json['{date} の数値'].gsub('{date}', d)

  # 検査の陽性率
  d = number_to_delimited(page.evaluate_script("#{POSITIVE_RATE_JSON['data'].last['positive_rate']}.toFixed(1)"))
  expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(1) > div > span > strong').text).to eq d.to_s

  # 検査の陽性率(実際に計算する)
  a = DAILY_POSITIVE_DETAIL_JSON['data'][-7..].reduce(0) { |sum, n| sum + n['count'].to_i }
  b = POSITIVE_RATE_JSON['data'].last['positive_rate']
  expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(1) > div > span > strong').text).to eq d.to_s

  # PCR検査の7日間移動平均(実際に計算する)
  d = number_to_delimited(POSITIVE_RATE_JSON['data'].last['weekly_average_diagnosed_count'])
  expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(2) > div > span > strong').text).to eq d.to_s

  # データを表示ボタンの文言
  expect(find('#PositiveRateCard .DataViewExpansionPanel button.v-expansion-panel-header').text).to eq lang_json['Common']['データを表示']

  # データを表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel--active')
  find('#PositiveRateCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel--active')

  # テーブルの上から4行目をチェックする(日付)
  if lang == :ja
    d = Date.parse(POSITIVE_RATE_JSON['data'][-4]['diagnosed_date']).strftime('%-m月%-d日')
  end
  if lang == :en
    d = Date.parse(POSITIVE_RATE_JSON['data'][-4]['diagnosed_date']).strftime('%b %-d')
  end
  expect(find('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(4) > th > time').text).to eq d.to_s

  d = Date.parse(POSITIVE_RATE_JSON['data'][-4]['diagnosed_date']).strftime('%Y-%m-%d')
  expect(find('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(4) > th > time')['datetime']).to eq d.to_s

  # テーブルの上から4行目をチェックする(陽性)
  d = number_to_delimited(POSITIVE_RATE_JSON['data'][-4]['pcr_positive_count'].to_i + POSITIVE_RATE_JSON['data'][-4]['antigen_positive_count'].to_i)
  expect(find('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(4) > td:nth-child(2)').text).to eq d.to_s

  # テーブルの上から4行目をチェックする(陰性)
  d = number_to_delimited(POSITIVE_RATE_JSON['data'][-4]['pcr_negative_count'].to_i + POSITIVE_RATE_JSON['data'][-4]['antigen_negative_count'].to_i)
  expect(find('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(4) > td:nth-child(3)').text).to eq d.to_s

  # テーブルの上から4行目をチェックする(検査件数 7-MA)
  d = number_to_delimited(page.evaluate_script("#{POSITIVE_RATE_JSON['data'][-4]['weekly_average_diagnosed_count']}.toFixed(1)"))
  expect(find('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(4) > td:nth-child(4)').text).to eq d.to_s

  # テーブルの上から4行目をチェックする(陽性率)
  d = number_to_delimited(page.evaluate_script("#{POSITIVE_RATE_JSON['data'][-4]['positive_rate']}.toFixed(1)"))
  expect(find('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(4) > td:nth-child(5)').text).to eq d.to_s

  # データを表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel--active')
  find('#PositiveRateCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel--active')

  # 注釈を表示ボタンの文言
  expect(find('#PositiveRateCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq lang_json['Common']['注']

  # 注釈を表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content')
  sleep 0.5
  find('#PositiveRateCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content')

  # 注釈の中身をチェック
  lang_json['PositiveRateCard']['notes'].each_with_index do |note, index|
    expect(find("#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content div[class^=newScenario] ul > li:nth-child(#{index + 1})").text).to eq note
  end

  # 注釈を表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#PositiveRateCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content')

  # データを表示と注釈を表示の両方を開く
  expect(page).not_to have_selector('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel--active')
  expect(page).not_to have_selector('#PositiveRateCard .NotesExpansionPanel .v-expansion-panel--active')
  find('#PositiveRateCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  sleep 1
  find('#PositiveRateCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel--active')
  expect(page).to have_selector('#PositiveRateCard .NotesExpansionPanel .v-expansion-panel--active')
end
