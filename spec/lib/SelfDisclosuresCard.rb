# frozen_string_literal: true

require 'spec_helper'

def has_self_disclosures_card(lang:, lang_json:, is_single: false)
  # h3
  expect(find('#SelfDisclosuresCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq lang_json['SelfDisclosuresCard']['title'].to_s
  d = find('#SelfDisclosuresCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  lang_prefix = lang == :ja ? '' : "/#{lang}"
  expect(URI.parse(d).path).to eq "#{lang_prefix}/cards/self-disclosures/"

  # テーブルの中身
  SELF_DISCLOSURES_ITEMS.each_with_index do |d, index|
    break if index > 9
    text = d['text'][lang.to_s] || d['text']['ja']
    url = d['url'][lang.to_s] || d['url']['ja']

    # テーブルの上から10行目までをチェックする(icon + text)
    if url.blank?
      expect(page).not_to have_selector("#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1 + index}) > td:nth-child(1) > a")
      expect(find("#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1 + index}) > td:nth-child(1)").text).to eq text.to_s
    else
      expect(find("#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1 + index}) > td:nth-child(1) > a").text).to eq "#{text}".rstrip
    end

    # テーブルの上からi行目をチェックする(日付)
    if lang == :ja
      expect(find("#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1 + index}) > td:nth-child(2) > time").text).to eq Date.parse(d['date']).strftime('%-m月%-d日').to_s
    end
    if lang == :en
      expect(find("#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1 + index}) > td:nth-child(2) > time").text).to eq Date.parse(d['date']).strftime('%b %-d').to_s
    end
    expect(find("#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1 + index}) > td:nth-child(2) > time")['datetime']).to eq Date.parse(d['date']).strftime('%Y-%m-%d').to_s
  end

  # 情報提供フォームはDataSetPanelの中
  expect(find('#SelfDisclosuresCard > div > div > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > div.DataView-DataSet-DataInfo-SelfDisclosureForm > a').text).to eq '情報提供フォーム'
  expect(find('#SelfDisclosuresCard > div > div > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > div.DataView-DataSet-DataInfo-SelfDisclosureForm > a')[:href]).to eq 'https://forms.gle/JHB4HJ2c4NnPcmy69'

  if is_single
    # 最初は1ページあたり20件なので11番目のtrは有る
    expect(page.all('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(11)').empty?).to eq false
    # 最初は1ページあたり20件なので21番目のtrは無い
    expect(page.all('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(21)').empty?).to eq true
  else
    # 最初は1ページあたり10件なので11番目のtrは無い
    expect(page.all('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(11)').empty?).to eq true
  end

  # 項目中
  d = SELF_DISCLOSURES_ITEMS.size
  if is_single
    expect(find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-footer > div.v-data-footer__pagination').text).to eq lang_json['DataView_Footer'][1].to_s.gsub('{itemsLength}', d.to_s).gsub('{pageStart}', '1').gsub('{pageStop}', d < 10 ? d.to_s : '20').rstrip
  else
    expect(find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-footer > div.v-data-footer__pagination').text).to eq lang_json['DataView_Footer'][1].to_s.gsub('{itemsLength}', d.to_s).gsub('{pageStart}', '1').gsub('{pageStop}', d < 10 ? d.to_s : '10').rstrip
  end

  if is_single
    # １ページあたり20件
    expect(find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-footer > div.v-data-footer__select').text).to eq "#{lang_json['DataView_Footer'][0]}\n20"
  else
    # １ページあたり10件
    expect(find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-footer > div.v-data-footer__select').text).to eq "#{lang_json['DataView_Footer'][0]}\n10"
  end

  # 次のページ
  find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-footer > div.v-data-footer__icons-after > button').click

  # 次のページの先頭は11番目の要素。enがなければja
  if is_single
    d = SELF_DISCLOSURES_ITEMS[20]['text'][lang.to_s] || SELF_DISCLOSURES_ITEMS[20]['text']['ja']
    expect(find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td.text-start').text).to eq d.to_s
  else
    d = SELF_DISCLOSURES_ITEMS[10]['text'][lang.to_s] || SELF_DISCLOSURES_ITEMS[10]['text']['ja']
    expect(find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td.text-start').text).to eq d.to_s
  end

  # さらに次のページ
  find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-footer > div.v-data-footer__icons-after > button').click

  # # さらに次のページの先頭は21番目の要素。enがなければja
  # if is_single
  #   d = SELF_DISCLOSURES_ITEMS[20]['text'][lang.to_s] || SELF_DISCLOSURES_ITEMS[20]['text']['ja']
  #   expect(find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td.text-start').text).to eq d.to_s
  # else
  #   d = SELF_DISCLOSURES_ITEMS[10]['text'][lang.to_s] || SELF_DISCLOSURES_ITEMS[10]['text']['ja']
  #   expect(find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td.text-start').text).to eq d.to_s
  # end
end
