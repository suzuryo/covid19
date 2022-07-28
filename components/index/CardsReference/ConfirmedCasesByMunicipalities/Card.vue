<template>
  <v-col
    id="ConfirmedCasesByMunicipalitiesCard"
    cols="12"
    :md="isSingleCard || md"
    class="DataCard"
  >
    <client-only>
      <confirmed-cases-by-municipalities-table
        :title="$t('ConfirmedCasesByMunicipalitiesCard.title')"
        :title-id="'number-of-confirmed-cases-by-municipalities'"
        :chart-data="municipalitiesTable"
        :date="date"
        :info="info"
      >
        <template #notes>
          <ul>
            <li
              v-for="note in $t('ConfirmedCasesByMunicipalitiesCard.notes')"
              :key="note"
            >
              {{ note }}
            </li>
          </ul>
        </template>
      </confirmed-cases-by-municipalities-table>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script>
import dayjs from 'dayjs'

import ConfirmedCasesByMunicipalitiesTable from '@/components/index/CardsReference/ConfirmedCasesByMunicipalities/Table.vue'
import PatientMunicipalities from '@/data/patient_municipalities.json'
import { isSingleCard } from '@/utils/urls'

export default {
  components: {
    ConfirmedCasesByMunicipalitiesTable,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    // 市町村ごとの陽性患者数
    const municipalitiesTable = {
      headers: [],
      datasets: [],
    }

    // ヘッダーを設定
    municipalitiesTable.headers = [
      {
        text: this.$t('ConfirmedCasesByMunicipalitiesCard.legends[0]'),
        value: 'label',
      },
      {
        text: this.$t('ConfirmedCasesByMunicipalitiesCard.legends[1]'),
        value: 'count',
        align: 'end',
      },
      {
        text: this.$t('ConfirmedCasesByMunicipalitiesCard.legends[2]'),
        value: 'count_per_population',
        align: 'end',
      },
      {
        text: this.$t('ConfirmedCasesByMunicipalitiesCard.legends[3]'),
        value: 'last7days',
        align: 'end',
      },
      {
        text: this.$t('ConfirmedCasesByMunicipalitiesCard.legends[4]'),
        value: 'last7_per_100k',
        align: 'end',
      },
    ]

    const getCountPerPopulation = (d) => {
      return d === null ? '' : `${d}%`
    }

    // データを追加
    municipalitiesTable.datasets = PatientMunicipalities.datasets.data
      .filter((d) => d.label !== '小計')
      .map((d) => {
        return {
          code: d.code,
          ruby: this.$t(d.ruby),
          label: this.$t(d.label),
          count: d.count,
          count_per_population: getCountPerPopulation(d.count_per_population),
          last7days: d.last7days,
          last7_per_100k: d.last7_per_100k,
        }
      })

    const date = dayjs(PatientMunicipalities.date).format('YYYY/MM/DD HH:mm')

    const info = {
      sText: this.$t('Common.{date}の累計', {
        date: this.$d(
          new Date(PatientMunicipalities.datasets.date),
          'dateWithoutYear'
        ),
      }),
    }

    return {
      date,
      municipalitiesTable,
      info,
    }
  },
  computed: {
    isSingleCard() {
      return isSingleCard(this.$route.path)
    },
  },
}
</script>
