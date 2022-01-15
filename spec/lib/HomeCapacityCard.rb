# frozen_string_literal: true

require 'spec_helper'

def has_home_capacity_card(lang:, lang_json:)
  # h3
  expect(find('#HomeCapacityCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq lang_json['HomeCapacityCard']['title'].to_s
  d = find('#HomeCapacityCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  lang_prefix = lang == :ja ? '' : "/#{lang}"
  expect(URI.parse(d).path).to eq "#{lang_prefix}/cards/home-capacity/"

  # DataSetPanel
  expect(find('#HomeCapacityCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > span.lTextBefore').text).to eq lang_json['Common']['現在']
  # 現在の状況
  d = MAIN_SUMMARY_JSON['自宅療養']
  expect(find('#HomeCapacityCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > strong').text).to eq d.to_s
  expect(find('#HomeCapacityCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > small.DataView-DataSet-DataInfo-summary-unit').text).to eq lang_json['Common']['人'].gsub(/^\s/, '')


  maxBeds = MAIN_SUMMARY_JSON['自宅療養']

  maxBeds.times do |i|
    # 50ごとにspanに数字が書いてある
    if i % 50 == 49 || i == MAIN_SUMMARY_JSON['自宅療養'] - 1
      expect(find("#HomeCapacityCard > div > div > div.DataView-Content > div.Beds > div.Bed:nth-child(#{i+1}) > span").text).to eq "#{i+1}"
    end

    # Bed 療養中
    if i < MAIN_SUMMARY_JSON['自宅療養']
      expect(find("#HomeCapacityCard > div > div > div.DataView-Content > div.Beds > div.Bed.inuse:nth-child(#{i+1})")[:title]).to eq "#{i+1}"
    end
  end

  # 凡例1
  expect(page).to have_selector('#HomeCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(1) > span.Bed.inuse', count:1)
  expect(find('#HomeCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(1)').text).to eq lang_json['HotelCapacityCard']['療養中']

  # Notes
  find('#HomeCapacityCard > div > div > div > div.NotesExpansionPanel > div > div > button').click
  lang_json['HomeCapacityCard']['notes'].each_with_index do |item, i|
    expect(find("#HomeCapacityCard > div > div > div:nth-child(6) > div > div > div > div > div > ul > li:nth-child(#{1 + i})").text).to eq item
  end
end
