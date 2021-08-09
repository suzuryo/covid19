<template>
  <v-col id="StageCard" cols="12" :md="12" class="DataCard">
    <client-only>
      <stage-table
        :date="date"
        :info-titles="[$t('StageCard.title')]"
        :title-id="`stage`"
        :get-formatter="getFormatter"
        :table-data="tableData"
      >
        <template #notes>
          <ul>
            <li v-for="(note, i) in $t('StageCard.notes')" :key="i">
              {{ note }}
            </li>
          </ul>
        </template>
      </stage-table>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import dayjs from 'dayjs'
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'

import StageTable from '@/components/index/CardsMonitoring/Stage/Table.vue'
import DailyPositiveDetail from '@/data/daily_positive_detail.json'
import Data from '@/data/data.json'
import MainSummary from '@/data/main_summary.json'
import PositiveRate from '@/data/positive_rate.json'
import { getNumberToFixedFunction } from '@/utils/monitoringStatusValueFormatters'

type DataType = {
  date: string
  tableData: number[]
}
type MethodsType = {}
type ComputedType = {}
type PropsType = {}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  DataType,
  MethodsType,
  ComputedType,
  PropsType
> = {
  components: {
    StageTable,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    const date = DailyPositiveDetail.date

    const getFormatter = () => {
      return getNumberToFixedFunction(1)
    }

    // 計算前のデータ準備
    const positiveRateLast7days = PositiveRate.data.filter((a) =>
      dayjs(a.diagnosed_date).isAfter(
        dayjs(
          Data.patients_summary.data[Data.patients_summary.data.length - 1].日付
        ).add(-8, 'days') // 確定日の翌日に発表があるので -7 じゃなくて -8
      )
    )

    const dailyPositiveDetailLast7days = DailyPositiveDetail.data.filter((a) =>
      dayjs(a.diagnosed_date).isAfter(
        dayjs(
          Data.patients_summary.data[Data.patients_summary.data.length - 1].日付
        ).add(-8, 'days') // 確定日の翌日に発表があるので -7 じゃなくて -8
      )
    )

    // 直近1週間の陽性件数
    const positiveCountLast7Days = positiveRateLast7days.reduce((a, c) => {
      return a + c.positive_count
    }, 0)

    // 直近1週間の検査件数
    const pcrCountLast7Days = positiveRateLast7days.reduce((a, c) => {
      return (
        a +
        c.pcr_positive_count +
        (c.antigen_positive_count ?? 0) +
        c.pcr_negative_count +
        (c.antigen_negative_count ?? 0)
      )
    }, 0)

    // 療養者数
    const hospitalHotelCountToday =
      MainSummary.入院 +
      MainSummary.宿泊療養 +
      MainSummary.自宅療養 +
      MainSummary.調整中

    // ここから計算
    // 0で割り算になる場合は 99999 を返しておく

    // 確保病床の使用率
    const stageIndex0 = (MainSummary.入院 / 350.0) * 100

    // 入院率
    const stageIndex1 =
      hospitalHotelCountToday === 0 || hospitalHotelCountToday < 10
        ? 99999
        : (MainSummary.入院 / hospitalHotelCountToday) * 100

    // 確保病床の使用率(重症者用)
    const stageIndex2 = (MainSummary.重症 / 45) * 100

    // 療養者数(対人口10万人)
    const stageIndex3 = (hospitalHotelCountToday * 100000) / 1211206

    // PCR陽性率(直近1週間)
    const stageIndex4 =
      pcrCountLast7Days === 0
        ? 99999
        : (positiveCountLast7Days / pcrCountLast7Days) * 100

    // 新規陽性者数(直近1週間・対人口10万人)
    const stageIndex5 = (positiveCountLast7Days * 100000) / 1211206

    const stageIndex6 =
      positiveCountLast7Days === 0
        ? 99999
        : (dailyPositiveDetailLast7days.reduce((a, c) => {
            return a + c.missing_count
          }, 0) /
            positiveCountLast7Days) *
          100

    const tableData = [
      stageIndex0,
      stageIndex1,
      stageIndex2,
      stageIndex3,
      stageIndex4,
      stageIndex5,
      stageIndex6,
    ]

    return {
      date,
      getFormatter,
      tableData,
    }
  },
}

export default Vue.extend(options)
</script>
