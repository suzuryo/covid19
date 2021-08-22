<template>
  <v-col id="AgeGroupCard" cols="12" :md="md" class="DataCard">
    <client-only>
      <age-chart
        title-id="age-group"
        :info-titles="[$t('AgeGroupCard.title')]"
        chart-id="age-group-chart"
        :chart-data="chartData7MA"
        :get-formatter="getFormatter"
        :date="date"
        :labels="labels7MA"
        :data-labels="ageLabels"
        :table-labels="ageLabels"
      >
        <template #notes>
          <ul>
            <li v-for="(note, i) in $t('AgeGroupCard.notes')" :key="i">
              {{ note }}
            </li>
          </ul>
        </template>
      </age-chart>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'
import { TranslateResult } from 'vue-i18n'

import AppLink from '@/components/_shared/AppLink.vue'
import AgeChart from '@/components/index/CardsMonitoring/AgeGroup/Chart.vue'
import DailyPositiveDetail from '@/data/daily_positive_detail.json'
import Data from '@/data/data.json'
import { getNumberToFixedFunction } from '@/utils/monitoringStatusValueFormatters'

type DataType = {
  ageLabels: string[] | TranslateResult[]
  date: string
  dataLabels: string[] | TranslateResult[]
  tableLabels: string[] | TranslateResult[]
  getFormatter: Function
  labels7MA: string[]
  chartData7MA: number[][]
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
    AppLink,
    AgeChart,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    const ages = [
      '10歳未満',
      '10代',
      '20代',
      '30代',
      '40代',
      '50代',
      '60代',
      '70代',
      '80代',
      '90歳以上',
    ]

    const ageLabels = [
      this.$t('ConfirmedCasesAttributesCard.table.10歳未満'),
      this.$t('ConfirmedCasesAttributesCard.table.{age}代', { age: 10 }),
      this.$t('ConfirmedCasesAttributesCard.table.{age}代', { age: 20 }),
      this.$t('ConfirmedCasesAttributesCard.table.{age}代', { age: 30 }),
      this.$t('ConfirmedCasesAttributesCard.table.{age}代', { age: 40 }),
      this.$t('ConfirmedCasesAttributesCard.table.{age}代', { age: 50 }),
      this.$t('ConfirmedCasesAttributesCard.table.{age}代', { age: 60 }),
      this.$t('ConfirmedCasesAttributesCard.table.{age}代', { age: 70 }),
      this.$t('ConfirmedCasesAttributesCard.table.{age}代', { age: 80 }),
      this.$t('ConfirmedCasesAttributesCard.table.90歳以上'),
    ]

    const dataLabels = ageLabels
    const tableLabels = ageLabels

    const date = DailyPositiveDetail.date

    const getFormatter = () => {
      // 7日間移動平均は小数点第2位まで表示する。
      return getNumberToFixedFunction(1)
    }

    const patients = Data.patients.data

    const labels = DailyPositiveDetail.data.map((a) => a.diagnosed_date)

    const chartData = ages.map((age) => {
      return labels.map((a) => {
        return patients.filter((b) => b.確定日 === a && b.年代 === age).length
      })
    })

    const labels7MA = DailyPositiveDetail.data
      .slice(6)
      .map((a) => a.diagnosed_date)

    const chartData7MA: [number[]] = [[]]
    chartData.forEach((a, i) => {
      chartData7MA[i] = []
      a.forEach((_b, j) => {
        if (j > 5) {
          chartData7MA[i].push(
            (a[j - 6] +
              a[j - 5] +
              a[j - 4] +
              a[j - 3] +
              a[j - 2] +
              a[j - 1] +
              a[j]) /
              7.0
          )
        }
      })
    })

    return {
      ageLabels,
      date,
      dataLabels,
      tableLabels,
      getFormatter,
      labels7MA,
      chartData7MA,
    }
  },
}

export default Vue.extend(options)
</script>
