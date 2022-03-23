# frozen_string_literal: true

require 'spec_helper'

def has_confirmed_case_attributes_card
  # h3
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Header > div > div > h3').text).to eq JA_JSON['ConfirmedCasesAttributesCard']['title']
  d = find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  expect(URI.parse(d).path).to eq '/cards/attributes-of-confirmed-cases/'

  # 陽性者の合計
  d = DATA_JSON['patients']['data'].size
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Header > div > div > div > span > strong').text).to eq d.to_s

  # 陽性者の合計の日付
  d = Date.parse(DATA_JSON['patients']['data'].last['確定日']).strftime('%-m月%-d日')
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Header > div > div > div > small').text).to eq JA_JSON['Common']['{date}の累計'].gsub('{date}', d)

  # テーブルの上から1行目をチェックする(通番)
  d = DATA_JSON['patients']['data'].last['id'].to_s
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > th').text).to eq d.to_s

  # テーブルのヘッダーをチェックする
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > thead > tr > th:nth-child(1)').text).to eq JA_JSON['ConfirmedCasesAttributesCard']['table']['通番']
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > thead > tr > th:nth-child(2)').text).to eq JA_JSON['ConfirmedCasesAttributesCard']['table']['確定日']
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > thead > tr > th:nth-child(3)').text).to eq JA_JSON['ConfirmedCasesAttributesCard']['table']['発症日']
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > thead > tr > th:nth-child(4)').text).to eq JA_JSON['ConfirmedCasesAttributesCard']['table']['居住地']
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > thead > tr > th:nth-child(5)').text).to eq JA_JSON['ConfirmedCasesAttributesCard']['table']['年代']
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > thead > tr > th:nth-child(6)').text).to eq JA_JSON['ConfirmedCasesAttributesCard']['table']['接触歴']

  # テーブルの上から1行目をチェックする(url)
  d = DATA_JSON['patients']['data'].last['url']
  if d
    expect(
      find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > th > a')[:href]
    ).to eq d.to_s
  end

  # テーブルの上から1行目をチェックする(確定日)
  d = Date.parse(DATA_JSON['patients']['data'].last['確定日']).strftime('%-m月%-d日')
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(2) > time').text).to eq d.to_s

  d = Date.parse(DATA_JSON['patients']['data'].last['確定日']).strftime('%Y-%m-%d')
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(2) > time')['datetime']).to eq d.to_s

  # テーブルの上から1行目をチェックする(発症日)
  d = if DATA_JSON['patients']['data'].last&.[]('発症日')
        "#{(Date.parse(DATA_JSON['patients']['data'].last&.[]('確定日')) - Date.parse(DATA_JSON['patients']['data'].last&.[]('発症日'))).to_i}日前"
      elsif DATA_JSON['patients']['data'].last&.[]('無症状')
        JA_JSON['ConfirmedCasesAttributesCard']['table']['無症状']
      elsif DATA_JSON['patients']['data'].last&.[]('調査中').nil?
        JA_JSON['ConfirmedCasesAttributesCard']['table']['調査中']
      else
        JA_JSON['ConfirmedCasesAttributesCard']['table']['不明']
      end
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq d.to_s

  # テーブルの上から1行目をチェックする(居住地と滞在地)
  d = if DATA_JSON['patients']['data'].last['居住地'].nil?
        JA_JSON['ConfirmedCasesAttributesCard']['table']['調査中']
      elsif DATA_JSON['patients']['data'].last['滞在地']
        "#{DATA_JSON['patients']['data'].last['居住地']} (#{DATA_JSON['patients']['data'].last['滞在地']})"
      else
        DATA_JSON['patients']['data'].last['居住地']
      end
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(4)').text).to eq d.to_s

  # テーブルの上から1行目をチェックする(年代)
  d = if DATA_JSON['patients']['data'].last['年代'].nil?
        JA_JSON['ConfirmedCasesAttributesCard']['table']['調査中']
      else
        DATA_JSON['patients']['data'].last['年代']
      end
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(5)').text).to eq d.to_s

  # テーブルの上から1行目をチェックする(接触)
  d = if  DATA_JSON['patients']['data'].last['接触歴'].nil?
        JA_JSON['ConfirmedCasesAttributesCard']['table']['調査中']
      elsif DATA_JSON['patients']['data'].last['接触歴'] == '判明'
        ''
      else
        '無'
      end
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(6)').text).to eq d.to_s

  # 最初は1ページあたり15件なので16番目のtrは無い
  expect(page.all('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(16)').empty?).to eq true

  # １ページあたり
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-footer > div.v-data-footer__select').text).to eq "#{JA_JSON['DataView_Footer'][0]}\n15"

  # 項目中
  d = DATA_JSON['patients']['data'].size
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-footer > div.v-data-footer__pagination').text).to eq (JA_JSON['DataView_Footer'][1]).to_s.gsub('{itemsLength}', d.to_s).gsub('{pageStart}', '1').gsub('{pageStop}', d < 15 ? d.to_s : '15').rstrip

  # 次のページ
  find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-footer > div.v-data-footer__icons-after > button').click

  # 次のページの先頭は16番目の要素
  d = DATA_JSON['patients']['data'][-16]['id'].to_s
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > th').text).to eq d.to_s

  # 注釈を表示ボタンの文言
  expect(find('#ConfirmedCasesAttributesCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq JA_JSON['Common']['注']

  # 注釈を表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#ConfirmedCasesAttributesCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#ConfirmedCasesAttributesCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#ConfirmedCasesAttributesCard .NotesExpansionPanel .v-expansion-panel-content')

  # 注釈の中身をチェック
  JA_JSON['ConfirmedCasesAttributesCard']['notes'].each_with_index do |item, i|
    expect(find("#ConfirmedCasesAttributesCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(#{1 + i})").text).to eq item
  end

  # 注釈を表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#ConfirmedCasesAttributesCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#ConfirmedCasesAttributesCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#ConfirmedCasesAttributesCard .NotesExpansionPanel .v-expansion-panel-content')
end
