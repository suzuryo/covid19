<template>
  <v-col
    id="PositiveRateCard"
    cols="12"
    :md="isSingleCard || md"
    class="DataCard"
  >
    <client-only>
      <positive-rate-chart
        :title-id="'positive-rate'"
        :info-titles="[
          `${$t('PositiveRateCard.titles[0]')} *`,
          $t('PositiveRateCard.titles[1]'),
        ]"
        :chart-id="'positive-rate-chart'"
        :chart-data="positiveRateGraph"
        :get-formatter="getFormatter"
        :date="PositiveRate.date"
        :labels="positiveRateLabels"
        unit="% *"
        :option-unit="$t('件.reports')"
        :data-labels="positiveRateDataLabels"
        :table-labels="positiveRateTableLabels"
        :day-period="isSingleCard && $vuetify.breakpoint.mdAndUp ? 120 : 60"
      >
        <template #notes>
          <div :class="$style.newScenario">
            <ul>
              <li v-for="note in $t('PositiveRateCard.notes')" :key="note">
                {{ note }}
              </li>
            </ul>
          </div>
        </template>
      </positive-rate-chart>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script>
import { extend } from 'dayjs'
import duration from 'dayjs/plugin/duration'

import PositiveRateChart from '@/components/index/CardsMonitoring/PositiveRate/Chart'
import PositiveRate from '@/data/positive_rate.json'
import {
  getCommaSeparatedNumberToFixedFunction,
  getNumberToFixedFunction,
  getNumberToLocaleStringFunction,
} from '@/utils/monitoringStatusValueFormatters'
import { isSingleCard } from '@/utils/urls'

extend(duration)

export default {
  components: {
    PositiveRateChart,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    // 検査実施日別状況
    const { data } = PositiveRate

    const positiveCount = data.map(
      (d) => d.pcr_positive_count + d.antigen_positive_count
    )
    const negativeCount = data.map(
      (d) => d.pcr_negative_count + d.antigen_negative_count
    )

    const positiveRates = data.map((d) => d.positive_rate)
    const positiveRateLabels = data.map((d) => d.diagnosed_date)
    const weeklyAverageDiagnosedCount = data.map(
      (d) => d.weekly_average_diagnosed_count
    )
    const positiveRateGraph = [
      positiveCount,
      negativeCount,
      weeklyAverageDiagnosedCount,
      positiveRates,
    ]
    const positiveRateDataLabels = [
      this.$t('PositiveRateCard.陽性'),
      this.$t('PositiveRateCard.陰性'),
      this.$t('PositiveRateCard.検査件数（7日間移動平均）'),
      this.$t('PositiveRateCard.陽性率'),
    ]
    const positiveRateTableLabels = positiveRateDataLabels.map((d) => d)

    const getFormatter = (columnIndex) => {
      if (columnIndex === 2) {
        // 検査件数（７日間移動平均）は小数点第1位まで表示し、整数部分は３桁区切りにする。
        return getCommaSeparatedNumberToFixedFunction(1)
      } else if (columnIndex === 3) {
        // 陽性率は小数点第1位まで表示する。
        return getNumberToFixedFunction(1)
      } else {
        return getNumberToLocaleStringFunction()
      }
    }

    return {
      PositiveRate,
      positiveRateGraph,
      positiveRateLabels,
      positiveRateDataLabels,
      positiveRateTableLabels,
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

<style lang="scss" module>
.newScenario {
  hr {
    border-top: none;
    border-right: none;
    border-bottom: 1px solid $gray-4;
    border-left: none;
    margin-top: 20px;
    margin-bottom: 20px;
  }
  .newScenarioExternalLink {
    margin-bottom: 10px;
    text-align: right;
  }
}
</style>
