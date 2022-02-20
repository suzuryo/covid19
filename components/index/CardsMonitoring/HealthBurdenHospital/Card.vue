<template>
  <v-col
    id="HealthBurdenHospitalCard"
    cols="12"
    :md="isSingleCard || md"
    class="DataCard"
  >
    <client-only>
      <health-burden-hospital-chart
        title-id="health-burden-hospital"
        :info-titles="[$t('HealthBurdenHospitalCard.title')]"
        chart-id="health-burden-hospital-chart"
        :chart-data="chartData"
        :date="date"
        :labels="labels"
        :data-labels="dataLabels"
        :table-labels="tableLabels"
        :day-period="18"
      >
        <template #notes>
          <ul>
            <li
              v-for="(note, i) in $t('HealthBurdenHospitalCard.notes')"
              :key="i"
            >
              {{ note }}
            </li>
          </ul>
        </template>
      </health-burden-hospital-chart>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import dayjs from 'dayjs'
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'
import type { TranslateResult } from 'vue-i18n'

import AppLink from '@/components/_shared/AppLink.vue'
import HealthBurdenHospitalChart from '@/components/index/CardsMonitoring/HealthBurdenHospital/Chart.vue'
import HealthBurden from '@/data/health_burden.json'
import { isSingleCard } from '@/utils/urls'

type DataType = {
  healthBurdenLabels: string[] | TranslateResult[]
  date: string
  dataLabels: string[] | TranslateResult[]
  tableLabels: string[] | TranslateResult[]
  labels: string[] | TranslateResult[]
  chartData: number[][]
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
    AppLink,
    HealthBurdenHospitalChart,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    const healthBurdenLabels = [
      this.$t(
        'HealthBurdenHospitalCard.自宅療養や療養施設を積極的に利用した場合'
      ),
      this.$t(
        'HealthBurdenHospitalCard.ハイリスク軽症者やハイリスクでなくとも中等症1は基本的に入院させる場合'
      ),
      this.$t('HealthBurdenHospitalCard.確保病床400床'),
    ]

    const date = HealthBurden.date

    const dataLabels = healthBurdenLabels
    const tableLabels = healthBurdenLabels.slice(0, 2)

    const startDate = dayjs(date).add(3, 'day')
    const labels = [startDate.format('YYYY-MM-DD')]
    for (let i = 0; i < 18; i++) {
      labels.push(startDate.add(i + 1, 'day').format('YYYY-MM-DD'))
    }

    const chartData = [
      HealthBurden.自宅療養や療養施設を積極的に利用した場合データ,
      HealthBurden.基本的に入院させる場合データ,
      HealthBurden.酸素需要を要する人データ.map(() => {
        return 400
      }),
    ]

    return {
      healthBurdenLabels,
      date,
      dataLabels,
      tableLabels,
      labels,
      chartData,
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
