# frozen_string_literal: true

require 'spec_helper'

def has_stage_card(lang:, lang_json:)
  # h3
  expect(find('#StageCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq lang_json['StageCard']['title'].to_s
  d = find('#StageCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  lang_prefix = lang == :ja ? '' : "/#{lang}"
  expect(URI.parse(d).path).to eq "#{lang_prefix}/cards/stage/"

  # 注釈を表示ボタンの文言
  expect(find('#StageCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq lang_json['Common']['注']

  # 注釈を表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#StageCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#StageCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#StageCard .NotesExpansionPanel .v-expansion-panel-content')

  # 注釈の中身をチェック
  lang_json['StageCard']['notes'].each_with_index do |item, i|
    expect(find("#StageCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(#{1 + i})").text).to eq item
  end

  # 注釈を表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#StageCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#StageCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#StageCard .NotesExpansionPanel .v-expansion-panel-content')
end
