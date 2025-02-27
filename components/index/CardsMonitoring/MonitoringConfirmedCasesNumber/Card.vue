<template>
  <v-col
    id="MonitoringConfirmedCasesNumberCard"
    cols="12"
    :md="isSingleCard || md"
    class="DataCard"
  >
    <client-only>
      <monitoring-confirmed-cases-number-chart
        title-id="monitoring-number-of-confirmed-cases"
        :info-titles="[
          $t('MonitoringConfirmedCasesNumberCard.titles[0]'),
          $t('MonitoringConfirmedCasesNumberCard.titles[1]'),
        ]"
        chart-id="monitoring-confirmed-cases-chart"
        :chart-data="chartData"
        :get-formatter="getFormatter"
        :date="date"
        :labels="labels"
        :data-labels="dataLabels"
        :table-labels="tableLabels"
        :unit="$t('Common.人')"
        :day-period="isSingleCard && $vuetify.breakpoint.mdAndUp ? 120 : 60"
      >
        <template #notes>
          <ul>
            <li>
              {{ $t('Common.検査結果の判明日を基準とする') }}
            </li>
            <li
              v-for="(item, i) in $t('MonitoringConfirmedCasesNumberCard.a')"
              :key="i"
            >
              {{ item }}
            </li>
            <li>
              {{ $t('Common.7MA') }}
            </li>
          </ul>
        </template>
      </monitoring-confirmed-cases-number-chart>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script>
import MonitoringConfirmedCasesNumberChart from '@/components/index/CardsMonitoring/MonitoringConfirmedCasesNumber/Chart.vue'
import PositiveRate from '@/data/positive_rate.json'
import {
  getNumberToFixedFunction,
  getNumberToLocaleStringFunction,
} from '@/utils/monitoringStatusValueFormatters'
import { isSingleCard } from '@/utils/urls'

export default {
  components: {
    MonitoringConfirmedCasesNumberChart,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    const [patientsCount, sevenDayMoveAverages, labels] =
      PositiveRate.data.reduce(
        (res, data) => {
          res[0].push(data.positive_count)
          res[1].push(data.weekly_average_positive_count)
          res[2].push(data.diagnosed_date)
          return res
        },
        [[], [], []]
      )
    const chartData = [patientsCount, sevenDayMoveAverages]
    const dataLabels = [
      this.$t('Common.陽性者数'),
      this.$t('Common.７日間移動平均'),
    ]
    const tableLabels = [
      this.$t('Common.陽性者数'),
      this.$t('Common.７日間移動平均'),
    ]
    const date = PositiveRate.data.slice(-1)[0].diagnosed_date

    const getFormatter = (columnIndex) => {
      // 新規陽性者数の7日間移動平均は小数点第1位まで表示する。
      if (columnIndex === 1) {
        return getNumberToFixedFunction(1)
      }
      return getNumberToLocaleStringFunction()
    }

    return {
      chartData,
      date,
      labels,
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
