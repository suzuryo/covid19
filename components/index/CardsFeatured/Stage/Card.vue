<template>
  <v-col id="StageCard" cols="12" :md="isSingleCard || md" class="DataCard">
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
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'

import StageTable from '@/components/index/CardsFeatured/Stage/Table.vue'
import MainSummary from '@/data/main_summary.json'
import PositiveRate from '@/data/positive_rate.json'
import { getNumberToFixedFunction } from '@/utils/monitoringStatusValueFormatters'
import { isSingleCard } from '@/utils/urls'

type DataType = {
  date: string
  tableData: number[]
}
type MethodsType = {}
type ComputedType = {
  isSingleCard: boolean
}
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
    const date = MainSummary.date

    const getFormatter = () => {
      return getNumberToFixedFunction(1)
    }

    // 陽性数7MA
    const weeklyAveragePositiveCount =
      PositiveRate.data.at(-1)?.weekly_average_positive_count ?? 0
    // 検査件数7MA
    const weeklyAverageDiagnosedCount =
      PositiveRate.data.at(-1)?.weekly_average_diagnosed_count ?? 0

    // 直近1週間の陽性件数
    const positiveCountLast7Days = weeklyAveragePositiveCount * 7

    // 直近1週間の検査件数
    const pcrCountLast7Days = weeklyAverageDiagnosedCount * 7

    // 療養者数
    const hospitalHotelCountToday =
      MainSummary.入院 +
      MainSummary.宿泊療養 +
      MainSummary.自宅療養 +
      MainSummary.調整中

    // ここから計算
    // 0で割り算になる場合は 99999 を返しておく

    // 確保病床の使用率
    const stageIndex0 = (MainSummary.入院 / 435.0) * 100

    // 入院率
    const stageIndex1 =
      hospitalHotelCountToday === 0 || hospitalHotelCountToday < 10
        ? 99999
        : (MainSummary.入院 / hospitalHotelCountToday) * 100

    // 確保病床の使用率(重症者用)
    const stageIndex2 = (MainSummary.重症 / 34) * 100

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
      (weeklyAveragePositiveCount / weeklyAverageDiagnosedCount) * 100

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
  computed: {
    isSingleCard() {
      return isSingleCard(this.$route.path)
    },
  },
}

export default Vue.extend(options)
</script>
