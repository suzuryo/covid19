<template>
  <v-col id="AgeGroupCard" cols="12" :md="isSingleCard || md" class="DataCard">
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
        :day-period="isSingleCard && $vuetify.breakpoint.mdAndUp ? 120 : 60"
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
import type { TranslateResult } from 'vue-i18n'

import AppLink from '@/components/_shared/AppLink.vue'
import AgeChart from '@/components/index/CardsMonitoring/AgeGroup/Chart.vue'
import ConfirmedCaseAge from '@/data/confirmed_case_age.json'
import { getNumberToFixedFunction } from '@/utils/monitoringStatusValueFormatters'
import { isSingleCard } from '@/utils/urls'

type DataType = {
  ageLabels: string[] | TranslateResult[]
  date: string
  getFormatter: Function
  labels7MA: string[]
  chartData7MA: number[][]
}

type MethodsType = {}

type ComputedType = {
  isSingleCard: boolean
}

type PropsType = {}

type AgeName =
  | '10歳未満'
  | '10代'
  | '20代'
  | '30代'
  | '40代'
  | '50代'
  | '60代'
  | '70代'
  | '80代'
  | '90歳以上'

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
    const labels = ConfirmedCaseAge.data.map((d) => d.date)
    const labels7MA = labels
    const date = ConfirmedCaseAge.date

    const getFormatter = () => {
      // 7日間移動平均は小数点第2位まで表示する。
      return getNumberToFixedFunction(1)
    }

    const ages: AgeName[] = [
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

    const chartData7MA = ages.map((age) => {
      return labels.map((date) => {
        const a = ConfirmedCaseAge.data.find((d) => {
          return date === d.date
        })
        if (a !== undefined) {
          return a.data[age]
        } else {
          return 0
        }
      })
    })

    return {
      ageLabels,
      date,
      getFormatter,
      labels7MA,
      chartData7MA,
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
