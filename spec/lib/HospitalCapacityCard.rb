# frozen_string_literal: true

require 'spec_helper'

def has_hospital_capacity_card(lang:, lang_json:)
  # h3
  expect(find('#HospitalCapacityCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq lang_json['HospitalCapacityCard']['title'].to_s
  d = find('#HospitalCapacityCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  lang_prefix = lang == :ja ? '' : "/#{lang}"
  expect(URI.parse(d).path).to eq "#{lang_prefix}/cards/hospital-capacity/"

  # DataSetPanel
  expect(find('#HospitalCapacityCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > span.lTextBefore').text).to eq lang_json['残り']
  # 残り病床数
  d = 400 - MAIN_SUMMARY_JSON['入院']
  expect(find('#HospitalCapacityCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > strong').text).to eq d.to_s
  expect(find('#HospitalCapacityCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > small.DataView-DataSet-DataInfo-summary-unit').text).to eq lang_json['床'].gsub(/^\s/, '')

  maxBeds = MAIN_SUMMARY_JSON['入院'] + MAIN_SUMMARY_JSON['調整中'] > 400 ? MAIN_SUMMARY_JSON['入院'] + MAIN_SUMMARY_JSON['調整中'] : 400

  maxBeds.times do |i|
    # 50ごとにspanに数字が書いてある
    if i % 50 == 49 || i == MAIN_SUMMARY_JSON['入院'] - 1
      expect(find("#HospitalCapacityCard > div > div > div.DataView-Content > div.Beds > div.Bed:nth-child(#{i+1}) > span").text).to eq "#{i+1}"
    end

    # Bed 入院中
    if i < MAIN_SUMMARY_JSON['入院']
      expect(find("#HospitalCapacityCard > div > div > div.DataView-Content > div.Beds > div.Bed.inuse:nth-child(#{i+1})")[:title]).to eq "#{i+1}"
    end

    # Bed 調整中
    if i >= MAIN_SUMMARY_JSON['入院'] && i < MAIN_SUMMARY_JSON['入院'] + MAIN_SUMMARY_JSON['調整中']
      expect(find("#HospitalCapacityCard > div > div > div.DataView-Content > div.Beds > div.Bed.waiting:nth-child(#{i+1})")[:title]).to eq "#{i+1}"
    end

    # Beds 超過
    if i >= 400
      expect(find("#HospitalCapacityCard > div > div > div.DataView-Content > div.Beds > div.Bed.overflowed:nth-child(#{i+1})")[:title]).to eq "#{i+1}"
    end
  end

  # 凡例1
  expect(page).to have_selector('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(1) > span.Bed.inuse', count:1)
  expect(find('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(1)').text).to eq lang_json['HospitalCapacityCard']['入院中']
  expect(page).to have_selector('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(2) > span.Bed.waiting', count:1)
  expect(find('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(2)').text).to eq lang_json['HospitalCapacityCard']['入院療養等調整中']
  expect(page).to have_selector('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(3) > span.Bed', count:1)
  expect(find('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(3)').text).to eq lang_json['HospitalCapacityCard']['空き']

  # Notes
  find('#HospitalCapacityCard > div > div > div > div.NotesExpansionPanel > div > div > button').click
  lang_json['HospitalCapacityCard']['notes'].each_with_index do |item, i|
    expect(find("#HospitalCapacityCard > div > div > div:nth-child(6) > div > div > div > div > div > ul > li:nth-child(#{1 + i})").text).to eq item
  end

  if MAIN_SUMMARY_JSON['入院'] + MAIN_SUMMARY_JSON['調整中'] > 400
    expect(page).to have_selector('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(3) > span.Bed.overflowed', count:1)
    expect(find('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(3)').text).to eq lang_json['HospitalCapacityCard']['overflowed']
  else
    expect(page).to have_selector('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(3) > span.Bed.overflowed', count:0)
  end
end
