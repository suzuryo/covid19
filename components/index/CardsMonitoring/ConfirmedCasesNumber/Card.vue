<template>
  <v-col
    id="ConfirmedCasesNumberCard"
    cols="12"
    :md="isSingleCard || md"
    class="DataCard"
  >
    <client-only>
      <time-bar-chart
        :title="$t('ConfirmedCasesNumberCard.title')"
        :title-id="'number-of-confirmed-cases'"
        :chart-id="'time-bar-chart-patients'"
        :chart-data="patientsGraph"
        :date="PositiveRate.date"
        :unit="$t('Common.人')"
        :by-date="true"
        :day-period="isSingleCard && $vuetify.breakpoint.mdAndUp ? 120 : 60"
      />
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script>
import TimeBarChart from '@/components/index/_shared/TimeBarChart.vue'
import PositiveRate from '@/data/positive_rate.json'
import formatPositiveRateGraph from '@/utils/formatPositiveRateGraph'
import { isSingleCard } from '@/utils/urls'

export default {
  components: {
    TimeBarChart,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    // 感染者数グラフ
    const patientsGraph = formatPositiveRateGraph(PositiveRate.data)

    return {
      PositiveRate,
      patientsGraph,
    }
  },
  computed: {
    isSingleCard() {
      return isSingleCard(this.$route.path)
    },
  },
}
</script>
