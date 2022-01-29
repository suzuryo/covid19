# frozen_string_literal: true

require 'spec_helper'

def has_hotel_capacity_card(lang:, lang_json:)
  # h3
  expect(find('#HotelCapacityCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq lang_json['HotelCapacityCard']['title'].to_s
  d = find('#HotelCapacityCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  lang_prefix = lang == :ja ? '' : "/#{lang}"
  expect(URI.parse(d).path).to eq "#{lang_prefix}/cards/hotel-capacity/"

  # DataSetPanel
  expect(find('#HotelCapacityCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > span.lTextBefore').text).to eq lang_json['残り']
  # 残り病床数
  d = 300 - MAIN_SUMMARY_JSON['宿泊療養']
  expect(find('#HotelCapacityCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > strong').text).to eq d.to_s
  expect(find('#HotelCapacityCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > small.DataView-DataSet-DataInfo-summary-unit').text).to eq lang_json['室'].gsub(/^\s/, '')


  maxBeds = MAIN_SUMMARY_JSON['宿泊療養'] > 300 ? MAIN_SUMMARY_JSON['宿泊療養'] : 300

  maxBeds.times do |i|
    # 50ごとにspanに数字が書いてある
    if i % 50 == 49 || i == MAIN_SUMMARY_JSON['宿泊療養'] - 1
      expect(find("#HotelCapacityCard > div > div > div.DataView-Content > div.Beds > div.Bed:nth-child(#{i+1}) > span").text).to eq "#{i+1}"
    end

    # Bed 療養中
    if i < MAIN_SUMMARY_JSON['宿泊療養']
      expect(find("#HotelCapacityCard > div > div > div.DataView-Content > div.Beds > div.Bed.inuse:nth-child(#{i+1})")[:title]).to eq "#{i+1}"
    end
  end

  # 凡例1
  expect(page).to have_selector('#HotelCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(1) > span.Bed.inuse', count:1)
  expect(find('#HotelCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(1)').text).to eq lang_json['HotelCapacityCard']['療養中']
  expect(page).to have_selector('#HotelCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(2) > span.Bed', count:1)
  expect(find('#HotelCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(2)').text).to eq lang_json['HotelCapacityCard']['空き']

  # Notes
  find('#HotelCapacityCard > div > div > div > div.NotesExpansionPanel > div > div > button').click
  lang_json['HotelCapacityCard']['notes'].each_with_index do |item, i|
    expect(find("#HotelCapacityCard > div > div > div:nth-child(6) > div > div > div > div > div > ul > li:nth-child(#{1 + i})").text).to eq item
  end

  if MAIN_SUMMARY_JSON['宿泊療養'] > 300
    expect(page).to have_selector('#HotelCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(3) > span.Bed.overflowed', count:1)
    expect(find('#HotelCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(3)').text).to eq lang_json['HotelCapacityCard']['overflowed']
  else
    expect(page).to have_selector('#HotelCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(3) > span.Bed.overflowed', count:0)
  end
end
