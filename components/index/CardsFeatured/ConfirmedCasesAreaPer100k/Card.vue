<template>
  <v-col
    id="ConfirmedCasesAreaPer100kCard"
    cols="12"
    :md="isSingleCard || md"
    class="DataCard"
  >
    <client-only>
      <confirmed-cases-area-per-100k-chart
        title-id="confirmed-cases-area-per-100k"
        :info-titles="[$t('ConfirmedCasesAreaPer100kCard.title')]"
        chart-id="confirmed-cases-area-per-100k-chart"
        :chart-data="chartDataPer100k"
        :get-formatter="getFormatter"
        :date="date"
        :labels="labelsPer100k"
        :data-labels="areaLabels"
        :table-labels="areaLabels"
        :day-period="isSingleCard && $vuetify.breakpoint.mdAndUp ? 120 : 60"
      >
        <template #notes>
          <ul>
            <li
              v-for="(note, i) in $t('ConfirmedCasesAreaPer100kCard.notes')"
              :key="i"
            >
              {{ note }}
            </li>
          </ul>
        </template>
      </confirmed-cases-area-per-100k-chart>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'
import { TranslateResult } from 'vue-i18n'

import ConfirmedCasesAreaPer100kChart from '@/components/index/CardsFeatured/ConfirmedCasesAreaPer100k/Chart.vue'
import ConfirmedCaseArea from '@/data/confirmed_case_area.json'
import { getNumberToFixedFunction } from '@/utils/monitoringStatusValueFormatters'
import { isSingleCard } from '@/utils/urls'

type DataType = {
  areaLabels: string[] | TranslateResult[]
  date: string
  getFormatter: Function
  labelsPer100k: string[]
  chartDataPer100k: number[][]
}

type MethodsType = {}

type ComputedType = {
  isSingleCard: boolean
}

type PropsType = {}

type AreaName =
  | '県全体'
  | '盛岡市'
  | '県央'
  | '中部'
  | '奥州'
  | '一関'
  | '大船渡'
  | '釜石'
  | '宮古'
  | '久慈'
  | '二戸'

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  DataType,
  MethodsType,
  ComputedType,
  PropsType
> = {
  components: {
    ConfirmedCasesAreaPer100kChart,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    const labels = ConfirmedCaseArea.data.map((d) => d.date)
    const labelsPer100k = labels
    const date = ConfirmedCaseArea.date

    const getFormatter = () => {
      // 小数点第2位まで表示する。
      return getNumberToFixedFunction(1)
    }

    const areas: AreaName[] = [
      '県全体',
      '盛岡市',
      '県央',
      '中部',
      '奥州',
      '一関',
      '大船渡',
      '釜石',
      '宮古',
      '久慈',
      '二戸',
    ]

    const areaLabels = [
      this.$t('ConfirmedCasesAreaCard.area.県全体'),
      this.$t('ConfirmedCasesAreaCard.area.盛岡'),
      this.$t('ConfirmedCasesAreaCard.area.県央'),
      this.$t('ConfirmedCasesAreaCard.area.中部'),
      this.$t('ConfirmedCasesAreaCard.area.奥州'),
      this.$t('ConfirmedCasesAreaCard.area.一関'),
      this.$t('ConfirmedCasesAreaCard.area.大船渡'),
      this.$t('ConfirmedCasesAreaCard.area.釜石'),
      this.$t('ConfirmedCasesAreaCard.area.宮古'),
      this.$t('ConfirmedCasesAreaCard.area.久慈'),
      this.$t('ConfirmedCasesAreaCard.area.二戸'),
    ]

    const chartDataPer100k = areas.map((area) => {
      return labels.map((date) => {
        const a = ConfirmedCaseArea.data.find((d) => {
          return date === d.date
        })
        if (a !== undefined) {
          return a.last7_per_100k[area]
        } else {
          return 0
        }
      })
    })

    return {
      areaLabels,
      date,
      getFormatter,
      labelsPer100k,
      chartDataPer100k,
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
