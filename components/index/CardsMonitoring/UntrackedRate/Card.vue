<template>
  <v-col
    id="UntrackedRateCard"
    cols="12"
    :md="isSingleCard || md"
    class="DataCard"
  >
    <client-only>
      <untracked-rate-chart
        :title-id="'untracked-rate'"
        :info-titles="[$t('UntrackedRateCard.titles[0]')]"
        :chart-id="'untracked-rate-chart'"
        :chart-data="graphData"
        :get-formatter="getFormatter"
        :date="updated"
        :labels="dateList"
        :unit="[$t('Common.人')]"
        :data-labels="dataLabels"
        :table-labels="tableLabels"
        :day-period="isSingleCard && $vuetify.breakpoint.mdAndUp ? 120 : 60"
      >
        <template #notes>
          <ul>
            <li v-for="(note, i) in $t('UntrackedRateCard.notes')" :key="i">
              {{ note }}
            </li>
            <li>
              {{ $t('Common.7MA') }}
            </li>
          </ul>
        </template>
      </untracked-rate-chart>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script>
import UntrackedRateChart from '@/components/index/CardsMonitoring/UntrackedRate/Chart'
import Data from '@/data/daily_positive_detail.json'
import {
  getNumberToFixedFunction,
  getNumberToLocaleStringFunction,
} from '@/utils/monitoringStatusValueFormatters'
import { isSingleCard } from '@/utils/urls'

export default {
  components: {
    UntrackedRateChart,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    const data = Data.data.filter(
      (d) => new Date(d.diagnosed_date) >= new Date('2020-03-27')
    )
    const reportedCount = data.map((d) => d.reported_count)
    const missingCount = data.map((d) => d.missing_count)
    const untrackedRate = data.map((d) => d.weekly_average_untracked_count)
    const dateList = data.map((d) => d.diagnosed_date)
    const updated = Data.date
    const graphData = [reportedCount, missingCount, untrackedRate]

    const dataLabels = [
      this.$t('接触歴等判明者数'),
      this.$t('接触歴等不明者数'),
      this.$t('UntrackedRateCard.titles[0]'),
    ]
    const tableLabels = [
      this.$t('接触歴等判明者数'),
      this.$t('接触歴等不明者数'),
      this.$t('UntrackedRateCard.titles[0]'),
    ]

    const getFormatter = (columnIndex) => {
      // 7日間移動平均は小数点第1位まで表示する。
      if (columnIndex === 2) {
        return getNumberToFixedFunction(1)
      }
      return getNumberToLocaleStringFunction()
    }

    return {
      updated,
      graphData,
      dateList,
      dataLabels,
      tableLabels,
      getFormatter,
    }
  },
  computed: {
    isSingleCard() {
      return isSingleCard(this.$route.path)
    },
  },
}
</script>
