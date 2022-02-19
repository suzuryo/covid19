<template>
  <data-view
    :title="title"
    :title-id="titleId"
    :date="date"
    :head-title="title + infoTitles.join(',')"
  >
    <ul
      :class="$style.GraphLegend"
      :style="{ display: canvas ? 'block' : 'none' }"
    >
      <li v-for="(item, i) in dataLabels" :key="i" @click="onClickLegend(i)">
        <button>
          <div
            :style="{
              background: colors[i].fillColor,
              border: 0,
              height: '3px',
            }"
          />
          <span
            :style="{
              textDecoration: displayLegends[i] ? 'none' : 'line-through',
            }"
            >{{ item }}</span
          >
        </button>
      </li>
    </ul>
    <h4 :id="`${titleId}-graph`" class="visually-hidden">
      {{ $t(`{title}のグラフ`, { title }) }}
    </h4>
    <div v-show="canvas">
      <bar
        :ref="'barChart'"
        :chart-id="chartId"
        :chart-data="displayData"
        :options="displayOption"
        :display-legends="displayLegends"
        :height="240"
        :width="300"
        :min="startDate"
        :max="endDate"
        :y-axis-max="scaledTicksYAxisMax"
      />
      <date-range-slider
        :id="titleId"
        :min-date="minDate"
        :max-date="maxDate"
        :default-day-period="dayPeriod"
        @start-date="startDate = $event"
        @end-date="endDate = $event"
      />
    </div>
    <template #notes>
      <notes-expansion-panel
        class="DataView-ExpansionPanel"
        :expansion-panel-text="$t('Common.注')"
      >
        <template #notes>
          <slot name="notes" />
        </template>
      </notes-expansion-panel>
    </template>
    <template #additionalDescription>
      <slot name="additionalDescription" />
    </template>
    <template #dataTable>
      <client-only>
        <data-view-table :headers="tableHeaders" :items="tableData" />
      </client-only>
    </template>
    <template #dataSetPanel>
      <data-view-data-set-panel
        :title="infoTitles[0]"
        :card-path="`/cards/${titleId}`"
      />
    </template>
  </data-view>
</template>

<script lang="ts">
import Chart from 'chart.js'
import dayjs, { extend } from 'dayjs'
import isBetween from 'dayjs/plugin/isBetween'
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'
import type { TranslateResult } from 'vue-i18n'

import DataView from '@/components/index/_shared/DataView.vue'
import NotesExpansionPanel from '@/components/index/_shared/DataView/NotesExpansionPanel.vue'
import DataViewDataSetPanel from '@/components/index/_shared/DataViewDataSetPanel.vue'
import DataViewTable, {
  TableHeader,
  TableItem,
} from '@/components/index/_shared/DataViewTable.vue'
import DateRangeSlider from '@/components/index/_shared/DateRangeSlider.vue'
import { DisplayData } from '@/plugins/vue-chart'
import { getGraphSeriesColor, SurfaceStyle } from '@/utils/colors'
import { getNumberToLocaleStringFunction } from '@/utils/monitoringStatusValueFormatters'

extend(isBetween)

type Data = {
  canvas: boolean
  displayLegends: boolean[]
  colors: SurfaceStyle[]
  startDate: string
  endDate: string
}
type Methods = {
  makeLineData: (value: number) => number[]
  onClickLegend: (i: number) => void
  startDateIndex: () => number
  endDateIndex: () => number
}

type Computed = {
  minDate: string
  maxDate: string
  displayData: DisplayData
  displayOption: Chart.ChartOptions
  scaledTicksYAxisMax: number
  tableHeaders: TableHeader[]
  tableData: TableItem[]
}

type Props = {
  title: string
  titleId: string
  infoTitles: string[]
  chartId: string
  chartData: number[][]
  getFormatter: Function
  date: string
  labels: string[]
  dataLabels: string[] | TranslateResult[]
  tableLabels: string[] | TranslateResult[]
  unit: string
  dayPeriod: number
}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  Data,
  Methods,
  Computed,
  Props
> = {
  components: {
    DataView,
    DataViewTable,
    DataViewDataSetPanel,
    NotesExpansionPanel,
    DateRangeSlider,
  },
  props: {
    title: {
      type: String,
      default: '',
    },
    titleId: {
      type: String,
      required: false,
      default: 'monitoring-number-of-confirmed-cases',
    },
    infoTitles: {
      type: Array,
      required: false,
      default: () => [],
    },
    chartId: {
      type: String,
      default: 'monitoring-confirmed-cases-chart',
    },
    chartData: {
      type: Array,
      required: false,
      default: () => [],
    },
    getFormatter: {
      type: Function,
      required: false,
      default: (_: number) => getNumberToLocaleStringFunction(),
    },
    date: {
      type: String,
      required: true,
      default: '',
    },
    labels: {
      type: Array,
      default: () => [],
    },
    dataLabels: {
      type: Array,
      default: () => [],
    },
    tableLabels: {
      type: Array,
      default: () => [],
    },
    unit: {
      type: String,
      default: '',
    },
    dayPeriod: {
      type: Number,
      default: 21,
    },
  },
  data() {
    const colors: SurfaceStyle[] = [
      getGraphSeriesColor('B'),
      getGraphSeriesColor('C'),
      getGraphSeriesColor('I'),
    ]
    return {
      displayLegends: [true, true, true],
      colors,
      canvas: true,
      startDate: this.labels[0],
      endDate: this.labels[this.labels?.length - 1],
    }
  },
  computed: {
    minDate() {
      return this.labels[0]
    },
    maxDate() {
      return this.labels[this.labels?.length - 1]
    },
    displayData() {
      const lineDataSets0 = {
        type: 'line',
        label: this.dataLabels[0],
        data: this.chartData[0].slice(
          this.startDateIndex(),
          this.endDateIndex() + 1
        ),
        pointRadius: 2,
        pointBackgroundColor: this.colors[0].fillColor,
        pointBorderColor: this.colors[0].fillColor,
        borderColor: this.colors[0].fillColor,
        borderWidth: 2,
        fill: false,
        order: 1,
        lineTension: 0,
      }
      const lineDataSets1 = {
        type: 'line',
        label: this.dataLabels[1],
        data: this.chartData[1].slice(
          this.startDateIndex(),
          this.endDateIndex() + 1
        ),
        pointRadius: 2,
        pointBackgroundColor: this.colors[1].fillColor,
        pointBorderColor: this.colors[1].fillColor,
        borderColor: this.colors[1].fillColor,
        borderWidth: 2,
        fill: false,
        order: 2,
        lineTension: 0,
      }
      const lineDataSets2 = {
        type: 'line',
        label: this.dataLabels[2],
        data: this.chartData[2].slice(
          this.startDateIndex(),
          this.endDateIndex() + 1
        ),
        pointBackgroundColor: 'rgba(0,0,0,0)',
        pointBorderColor: 'rgba(0,0,0,0)',
        borderColor: this.colors[2].fillColor,
        borderWidth: 2,
        fill: false,
        order: 3,
        lineTension: 0,
      }
      const rangeDate = this.labels.filter((item) => {
        const date = dayjs(item)
        return date.isBetween(this.startDate, this.endDate, 'day', '[]')
      })
      return {
        labels: rangeDate,
        datasets: [lineDataSets0, lineDataSets1, lineDataSets2],
      }
    },
    tableHeaders() {
      return [
        { text: this.$t('日付'), value: 'text' },
        ...(this.tableLabels as string[]).map((text, i) => {
          return { text, value: `${i}`, align: 'end' }
        }),
      ]
    },
    tableData() {
      return this.labels
        .map((label, i) => {
          return Object.assign(
            { text: label },
            ...(this.tableLabels as string[]).map((_, j) => {
              return {
                [j]: this.getFormatter(j)(this.chartData[j][i]),
              }
            })
          )
        })
        .sort((a, b) => dayjs(a.text).unix() - dayjs(b.text).unix())
        .reverse()
    },
    displayOption() {
      const unit = this.unit
      const options: Chart.ChartOptions = {
        tooltips: {
          displayColors: false,
          callbacks: {
            label: (tooltipItem) => {
              const cases = this.getFormatter(tooltipItem.datasetIndex!)(
                parseFloat(tooltipItem.value!)
              )
              return `${
                this.dataLabels[tooltipItem.datasetIndex!]
              } : ${cases} ${unit}`
            },
            title(tooltipItem, data) {
              if (tooltipItem[0].datasetIndex! < 2) {
                const date = data.labels![tooltipItem[0].index!].toString()
                return dayjs(date).format('M/D')
              }
              return ''
            },
          },
        },
        maintainAspectRatio: false,
        legend: {
          display: false,
        },
        scales: {
          xAxes: [
            {
              display: false, // day軸は非表示にしたいが、削除すると#2384のように見切れるので残す workaround
              id: 'day',
              stacked: true,
            },
            {
              id: 'month',
              stacked: true,
              gridLines: {
                drawOnChartArea: false,
                drawTicks: true,
                drawBorder: false,
                tickMarkLength: 10,
              },
              ticks: {
                fontSize: 11,
                fontColor: '#707070',
                padding: 3,
                fontStyle: 'bold',
              },
              type: 'time',
              time: {
                unit: 'month',
                displayFormats: {
                  month: 'MMM',
                },
              },
            },
          ],
          yAxes: [
            {
              id: 'monitoring-number-of-confirmed-cases',
              position: 'left',
              gridLines: {
                display: true,
                drawOnChartArea: true,
                color: '#E5E5E5', // #E5E5E5
              },
              ticks: {
                suggestedMin: 0,
                suggestedMax: this.scaledTicksYAxisMax,
                maxTicksLimit: 8,
                fontColor: '#707070', // #707070
              },
            },
          ],
        },
      }
      if (this.$route.query.ogp === 'true') {
        Object.assign(options, { animation: { duration: 0 } })
      }
      return options
    },
    scaledTicksYAxisMax() {
      const max = this.chartData.reduce(
        (max, data) =>
          Math.max(
            max,
            ...(data.slice(
              this.startDateIndex(),
              this.endDateIndex() + 1
            ) as number[])
          ),
        0
      )
      const digits = String(max).length
      const base = 10 ** (digits - 1)
      if (max <= 400) {
        return Math.ceil(max / base) * base + 100
      } else {
        return Math.ceil(max / base) * base
      }
    },
  },
  methods: {
    onClickLegend(i) {
      this.displayLegends[i] = !this.displayLegends[i]
      this.displayLegends = this.displayLegends.slice()
    },
    makeLineData(value: number): number[] {
      return this.chartData[0].map((_) => value)
    },
    startDateIndex() {
      const searchIndex = this.labels?.findIndex((item) => {
        const date = dayjs(item).format('YYYY-MM-DD')
        return date === this.startDate
      })
      return searchIndex === -1 ? 0 : searchIndex
    },
    endDateIndex() {
      const searchIndex = this.labels?.findIndex((item) => {
        const date = dayjs(item).format('YYYY-MM-DD')
        return date === this.endDate
      })
      return searchIndex === -1 ? this.labels?.length - 1 : searchIndex
    },
  },
  created() {
    this.canvas = process.browser
  },
  mounted() {
    const barChart = this.$refs.barChart as Vue
    const barElement = barChart.$el
    const canvas = barElement.querySelector('canvas')
    const labelledbyId = `${this.titleId}-graph`

    if (canvas) {
      canvas.setAttribute('role', 'img')
      canvas.setAttribute('aria-labelledby', labelledbyId)
    }

    this.$nextTick().then(() => {
      this.startDate = dayjs(this.maxDate)
        .subtract(this.dayPeriod, 'day')
        .format('YYYY-MM-DD')
    })
  },
}

export default Vue.extend(options)
</script>

<style module lang="scss">
.Graph {
  &Legend {
    text-align: center;
    list-style: none;
    padding: 0 !important;
    li {
      display: inline-block;
      margin: 0 3px;
      div {
        height: 12px;
        margin: 2px 4px;
        width: 40px;
        display: inline-block;
        vertical-align: middle;
        border-width: 1px;
        border-style: solid;
      }
      button {
        color: $gray-3;
        @include font-size(12);
      }
    }
  }
}
</style>
