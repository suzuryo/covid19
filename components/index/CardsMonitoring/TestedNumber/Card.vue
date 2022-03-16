<template>
  <v-col
    id="TestedNumberCard"
    cols="12"
    :md="isSingleCard || md"
    class="DataCard"
  >
    <client-only>
      <time-bar-chart
        :title="$t('TestedNumberCard.title')"
        :title-id="'number-of-tested'"
        :chart-id="'time-stacked-bar-chart-inspections'"
        :chart-data="inspectionsGraph"
        :date="PositiveRate.date"
        :unit="$t('件.tested')"
        :by-date="true"
        :day-period="isSingleCard && $vuetify.breakpoint.mdAndUp ? 120 : 60"
      >
        <template #notes>
          <ul>
            <li v-for="(note, i) in $t('TestedNumberCard.notes')" :key="i">
              {{ note }}
            </li>
          </ul>
        </template>
      </time-bar-chart>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script type="typescript">
import TimeBarChart from '@/components/index/_shared/TimeBarChart.vue'
import PositiveRate from '@/data/positive_rate.json'
import formatGraph from '@/utils/formatGraph'
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
    // 検査実施日別状況
    const totalTests = PositiveRate.data.map((d) => {
      return {
        日付: d.diagnosed_date,
        小計:
          (d.pcr_positive_count ?? 0) +
          (d.pcr_negative_count ?? 0) +
          (d.antigen_positive_count ?? 0) +
          (d.antigen_negative_count ?? 0),
      }
    })
    const inspectionsGraph = formatGraph(totalTests)

    return {
      PositiveRate,
      inspectionsGraph,
    }
  },
  computed: {
    isSingleCard() {
      return isSingleCard(this.$route.path)
    },
  },
}
</script>
