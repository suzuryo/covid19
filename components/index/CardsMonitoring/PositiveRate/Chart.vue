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
      <li
        v-for="(dataLabel, i) in dataLabels"
        :key="i"
        @click="onClickLegend(i)"
      >
        <button>
          <div
            v-if="i === 4"
            :style="{
              background: `repeating-linear-gradient(90deg, ${colors[i].fillColor}, ${colors[i].fillColor} 2px, #fff 2px, #fff 4px)`,
              border: 0,
              height: '3px',
            }"
          />
          <div
            v-else-if="i === 5"
            :style="{
              backgroundColor: colors[4].fillColor,
              border: 0,
              height: '3px',
            }"
          />
          <div
            v-else
            :style="{
              backgroundColor: colors[i].fillColor,
              borderColor: colors[i].strokeColor,
            }"
          />
          <span
            :style="{
              textDecoration: displayLegends[i] ? 'none' : 'line-through',
            }"
            >{{ dataLabel }}</span
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
        :l-text="displayInfo[0].lText"
        :s-text="displayInfo[0].sText"
        :unit="displayInfo[0].unit"
        :card-path="`/cards/${titleId}`"
      />
      <data-view-data-set-panel
        :title="infoTitles[1]"
        :l-text="displayInfo[1].lText"
        :s-text="displayInfo[1].sText"
        :unit="displayInfo[1].unit"
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
import {
  getGraphSeriesColor,
  getGraphSeriesStyle,
  SurfaceStyle,
} from '@/utils/colors'
import { calcDayBeforeRatio } from '@/utils/formatDayBeforeRatio'
import { getNumberToFixedFunction } from '@/utils/monitoringStatusValueFormatters'

extend(isBetween)

type Data = {
  canvas: boolean
  displayLegends: boolean[]
  colors: SurfaceStyle[]
  startDate: string
  endDate: string
}
type Methods = {
  onClickLegend: (i: number) => void
}
type DisplayInfo = {
  lText: string
  sText: string
  unit: string
}
type Computed = {
  minDate: string
  maxDate: string
  displayInfo: DisplayInfo[]
  displayData: DisplayData
  displayOption: Chart.ChartOptions
  scaledTicksYAxisMax: number
  scaledTicksYAxisMaxRight: number
  tableHeaders: TableHeader[]
  tableData: TableItem[]
  startDateIndex: number
  endDateIndex: number
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
  optionUnit: string
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
      default: '',
    },
    infoTitles: {
      type: Array,
      required: false,
      default: () => [],
    },
    chartId: {
      type: String,
      default: 'PositiveRateMixedChart',
    },
    chartData: {
      type: Array,
      required: false,
      default: () => [],
    },
    getFormatter: {
      type: Function,
      required: false,
      default: (_: number) => getNumberToFixedFunction(),
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
    optionUnit: {
      type: String,
      required: false,
      default: '',
    },
    dayPeriod: {
      type: Number,
      default: 60,
    },
  },
  data() {
    return {
      displayLegends: [true, true, true, true, true, true],
      colors: [...getGraphSeriesStyle(4), getGraphSeriesColor('E')],
      canvas: true,
      startDate: '2020-01-01',
      endDate: dayjs().format('YYYY-MM-DD'),
    }
  },
  computed: {
    minDate() {
      return dayjs(this.labels[0]).format('YYYY-MM-DD')
    },
    maxDate() {
      return dayjs(this.labels[this.labels?.length - 1]).format('YYYY-MM-DD')
    },
    displayInfo() {
      const data = {
        labels: this.labels,
        datasets: [
          { data: this.chartData[0] },
          { data: this.chartData[1] },
          { data: this.chartData[2] },
          { data: this.chartData[3] },
          { data: this.chartData[4] },
          { data: this.chartData[5] },
        ],
      }
      const { lastDay, lastDayData, dayBeforeRatio } = calcDayBeforeRatio({
        displayData: data,
        dataIndex: 5,
        digit: 1,
      })
      const {
        lastDay: lastDay4,
        lastDayData: lastDayData4,
        dayBeforeRatio: dayBeforeRatio4,
      } = calcDayBeforeRatio({
        displayData: this.displayData,
        dataIndex: 4,
        digit: 1,
      })

      return [
        {
          lText: lastDayData,
          sText: `${this.$t('{date} の数値', {
            date: this.$d(lastDay, 'dateWithoutYear'),
          })}（${this.$t('前日比')}: ${dayBeforeRatio} ${this.unit}）`,
          unit: this.unit,
        },
        {
          lText: lastDayData4,
          sText: `${this.$t('{date} の数値', {
            date: this.$d(lastDay4, 'dateWithoutYear'),
          })}（${this.$t('前日比')}: ${dayBeforeRatio4} ${this.optionUnit}）`,
          unit: this.optionUnit,
        },
      ]
    },
    displayData() {
      const rangeDate = this.labels.filter((item) => {
        const date = dayjs(item)
        return date.isBetween(this.startDate, this.endDate, null, '[]')
      })
      const graphSeries = [...getGraphSeriesStyle(4), getGraphSeriesColor('E')]
      return {
        labels: rangeDate,
        datasets: [
          {
            type: 'bar',
            yAxisID: 'y-axis-1',
            label: this.dataLabels[0],
            data: this.chartData[0].slice(
              this.startDateIndex,
              this.endDateIndex + 1
            ),
            backgroundColor: graphSeries[0].fillColor,
            borderColor: graphSeries[0].strokeColor,
            borderWidth: 1,
            order: 1,
          },
          {
            type: 'bar',
            yAxisID: 'y-axis-1',
            label: this.dataLabels[1],
            data: this.chartData[1].slice(
              this.startDateIndex,
              this.endDateIndex + 1
            ),
            backgroundColor: graphSeries[1].fillColor,
            borderColor: graphSeries[1].strokeColor,
            borderWidth: 1,
            order: 2,
          },
          {
            type: 'bar',
            yAxisID: 'y-axis-1',
            label: this.dataLabels[2],
            data: this.chartData[2].slice(
              this.startDateIndex,
              this.endDateIndex + 1
            ),
            backgroundColor: graphSeries[2].fillColor,
            borderColor: graphSeries[2].strokeColor,
            borderWidth: 1,
            order: 3,
          },
          {
            type: 'bar',
            yAxisID: 'y-axis-1',
            label: this.dataLabels[3],
            data: this.chartData[3].slice(
              this.startDateIndex,
              this.endDateIndex + 1
            ),
            backgroundColor: graphSeries[3].fillColor,
            borderColor: graphSeries[3].strokeColor,
            borderWidth: 1,
            order: 4,
          },
          {
            type: 'line',
            yAxisID: 'y-axis-1',
            label: this.dataLabels[4],
            data: this.chartData[4].slice(
              this.startDateIndex,
              this.endDateIndex + 1
            ),
            pointBackgroundColor: 'rgba(0,0,0,0)',
            pointBorderColor: 'rgba(0,0,0,0)',
            borderColor: graphSeries[4].strokeColor,
            borderWidth: 3,
            fill: false,
            order: 0,
            borderDash: [4, 4],
          },
          {
            type: 'line',
            yAxisID: 'y-axis-2',
            label: this.dataLabels[5],
            data: this.chartData[5].slice(
              this.startDateIndex,
              this.endDateIndex + 1
            ),
            pointBackgroundColor: 'rgba(0,0,0,0)',
            pointBorderColor: 'rgba(0,0,0,0)',
            borderColor: graphSeries[4].strokeColor,
            borderWidth: 3,
            fill: false,
            order: 0,
            lineTension: 0,
          },
        ],
      }
    },
    tableHeaders() {
      return [
        { text: this.$t('日付'), value: 'text' },
        ...(this.tableLabels as string[]).map((text, i) => {
          return { text, value: String(i), align: 'end' }
        }),
      ]
    },
    tableData() {
      return this.labels
        .map((label, i) => {
          return Object.assign(
            { text: label },
            ...(this.dataLabels as string[]).map((_, j) => {
              if (this.chartData[j][i] === null) {
                return {
                  [j]: '',
                }
              }
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
      const scaledTicksYAxisMaxRight = this.scaledTicksYAxisMaxRight
      const options: Chart.ChartOptions = {
        tooltips: {
          displayColors: false,
          callbacks: {
            label: (tooltipItem) => {
              const cases = this.getFormatter(tooltipItem.datasetIndex!)(
                parseFloat(tooltipItem.value!)
              )
              let label = `${
                this.dataLabels[tooltipItem.datasetIndex!]
              } : ${cases} ${this.$t('Common.人')}`
              if (tooltipItem.datasetIndex! >= 5) {
                label = `${
                  this.dataLabels[tooltipItem.datasetIndex!]
                } : ${cases} ${unit}`
              }
              return label
            },
            title: (tooltipItem, data) => {
              const label = data.labels![tooltipItem[0].index!].toString()
              return this.$d(new Date(label), 'dateWithoutYear')
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
              id: 'y-axis-1',
              position: 'left',
              stacked: true,
              gridLines: {
                display: true,
                drawOnChartArea: true,
                color: '#E5E5E5', // #E5E5E5
              },
              ticks: {
                suggestedMin: 0,
                maxTicksLimit: 8,
                fontColor: '#707070', // #707070
              },
            },
            {
              id: 'y-axis-2',
              position: 'right',
              gridLines: {
                display: true,
                drawOnChartArea: false,
                color: '#E5E5E5', // #E5E5E5
              },
              ticks: {
                suggestedMin: 0,
                maxTicksLimit: 8,
                fontColor: '#707070', // #707070
                suggestedMax: scaledTicksYAxisMaxRight,
                callback(value) {
                  return `${value}%`
                },
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
      const max = Array.from(this.chartData[0].keys())
        .map(
          (i) =>
            this.chartData[0][i] +
            this.chartData[1][i] +
            this.chartData[2][i] +
            this.chartData[3][i]
        )
        .reduce((a, b) => Math.max(a, b), 0)
      const digits = String(max).length
      const base = 10 ** (digits - 1)
      return Math.ceil(max / base) * base
    },
    scaledTicksYAxisMaxRight() {
      return this.chartData[5].reduce((a, b) => Math.max(a, b), 0)
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
  methods: {
    onClickLegend(i) {
      this.displayLegends[i] = !this.displayLegends[i]
      this.displayLegends = this.displayLegends.slice()
    },
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
