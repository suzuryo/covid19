<!--TimeStackedBarChartから 「日別・累計」のデータセレクターボタンを削除-->
<!--TimeStackedBarChartから データテーブル表示で「件数（日別）」のみを表示し「件数（累計）」は表示しない-->
<template>
  <data-view :title="title" :title-id="titleId" :date="date">
    <template #description>
      <slot name="description" />
    </template>
    <ul
      :class="$style.GraphLegend"
      :style="{ display: canvas ? 'block' : 'none' }"
    >
      <li v-for="(item, i) in items" :key="i" @click="onClickLegend(i)">
        <button>
          <div
            :style="{
              backgroundColor: colors[i].fillColor,
              borderColor: colors[i].strokeColor,
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
        :height="240"
        :width="300"
        :min="startDate"
        :max="endDate"
        :display-legends="displayLegends"
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
    <template #dataTable>
      <client-only>
        <data-view-table :headers="tableHeaders" :items="tableData" />
      </client-only>
    </template>
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
    <template #dataSetPanel>
      <data-view-data-set-panel
        :title="title"
        :l-text="displayInfo.lText"
        :s-text="displayInfo.sText"
        :unit="displayInfo.unit"
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

import DataSelector from '@/components/index/_shared/DataSelector.vue'
import DataView from '@/components/index/_shared/DataView.vue'
import NotesExpansionPanel from '@/components/index/_shared/DataView/NotesExpansionPanel.vue'
import DataViewDataSetPanel from '@/components/index/_shared/DataViewDataSetPanel.vue'
import DataViewTable, {
  TableHeader,
  TableItem,
} from '@/components/index/_shared/DataViewTable.vue'
import DateRangeSlider from '@/components/index/_shared/DateRangeSlider.vue'
import { DisplayData } from '@/plugins/vue-chart'
import { getGraphSeriesStyle, SurfaceStyle } from '@/utils/colors'
import { getComplementedDate, getDayjsObject } from '@/utils/formatDate'
import { getNumberToLocaleStringFunction } from '@/utils/monitoringStatusValueFormatters'

extend(isBetween)

type Data = {
  dataKind: 'transition'
  canvas: boolean
  displayLegends: boolean[]
  colors: SurfaceStyle[]
  isSmall: boolean
  startDate: string
  endDate: string
}
type Methods = {
  sum: (array: number[]) => number
  pickLastNumber: (chartDataArray: number[][]) => number[]
  onClickLegend: (i: number) => void
  handleResize: () => void
}

type Computed = {
  minDate: string
  maxDate: string
  displayInfo: {
    lText: string
    sText: string
    unit: string
  }
  displayData: DisplayData
  displayOption: Chart.ChartOptions
  scaledTicksYAxisMax: number
  tableHeaders: TableHeader[]
  tableData: TableItem[]
}

type Props = {
  title: string
  titleId: string
  chartId: string
  chartData: number[][]
  getFormatter: Function
  date: string
  items: string[]
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
  created() {
    this.canvas = process.browser
    this.dataKind = 'transition'
  },
  components: {
    DataView,
    DataSelector,
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
    chartId: {
      type: String,
      default: 'hospitalized-time-stacked-bar-chart',
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
    items: {
      type: Array,
      default: () => [],
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
      default: 60,
    },
  },
  data: () => ({
    dataKind: 'transition',
    displayLegends: [true, true, true, true],
    colors: getGraphSeriesStyle(5),
    canvas: true,
    isSmall: false,
    startDate: '2020-01-01',
    endDate: dayjs().format('YYYY-MM-DD'),
  }),
  computed: {
    minDate() {
      return this.labels[0]
    },
    maxDate() {
      return this.labels[this.labels.length - 1]
    },
    displayInfo() {
      const lastDay = this.labels[this.labels.length - 1]
      const date = this.$d(getDayjsObject(lastDay).toDate(), 'dateWithoutYear')

      return {
        lText: this.sum(this.pickLastNumber(this.chartData)).toLocaleString(),
        sText: `${this.$t('{date}の合計', { date })}`,
        unit: this.unit,
      }
    },
    displayData() {
      const graphSeries = getGraphSeriesStyle(5)
      return {
        labels: this.labels,
        datasets: this.chartData.map((item, index) => {
          return {
            label: this.items[index],
            data: item,
            backgroundColor: graphSeries[index].fillColor,
            borderColor: graphSeries[index].strokeColor,
            borderWidth: 1,
          }
        }),
      }
    },
    tableHeaders() {
      return [
        { text: this.$t('日付'), value: 'text' },
        ...(this.tableLabels as string[]).map((text, i) => {
          return { text, value: String(i), align: 'end' }
        }),
        { text: this.$t('計'), value: '4', align: 'end' },
      ]
    },
    tableData() {
      return this.labels
        .map((label, i) => {
          return Object.assign(
            {
              text: label,
            },
            ...this.chartData.map((_, j) => {
              // j=0が入院, j=1が宿泊療養, j=2が自宅療養, j=3が調整中
              const data = this.chartData[j]
              if (data[i] === null) {
                return {
                  [j]: '',
                }
              }
              return {
                [j]: this.getFormatter(j)(data[i]),
              }
            }),
            {
              // j=4で合計を計算
              4:
                this.chartData[0][i] +
                this.chartData[1][i] +
                this.chartData[2][i] +
                this.chartData[3][i],
            }
          )
        })
        .sort((a, b) => Date.parse(b.text) - Date.parse(a.text))
    },
    displayOption() {
      const unit = this.unit
      const data = this.chartData
      const options: Chart.ChartOptions = {
        tooltips: {
          displayColors: false,
          callbacks: {
            label: (tooltipItem) => {
              const cases =
                data[tooltipItem.datasetIndex!][
                  tooltipItem.index!
                ].toLocaleString()

              return `${
                this.dataLabels[tooltipItem.datasetIndex!]
              } : ${cases} ${unit}`
            },
            title: (tooltipItem, data) => {
              const label = data.labels![tooltipItem[0].index!] as string
              return this.$d(getComplementedDate(label), 'dateWithoutYear')
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
              stacked: true,
              gridLines: {
                display: true,
                color: '#E5E5E5',
              },
              ticks: {
                suggestedMin: 0,
                maxTicksLimit: 8,
                fontColor: '#707070',
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
      return Array.from(this.chartData[0].keys())
        .map((i) => this.chartData[0][i] + this.chartData[1][i])
        .reduce((a, b) => Math.max(a, b), 0)
    },
  },
  methods: {
    onClickLegend(i) {
      this.displayLegends[i] = !this.displayLegends[i]
      this.displayLegends = this.displayLegends.slice()
    },
    sum(array: number[]): number {
      return array.reduce((acc, cur) => {
        return acc + cur
      })
    },
    pickLastNumber(chartDataArray: number[][]) {
      return chartDataArray.map((array) => {
        return array[array.length - 1]
      })
    },
    handleResize() {
      this.isSmall = window.innerWidth <= 400
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

    window.addEventListener('resize', this.handleResize)
    this.handleResize()

    this.$nextTick().then(() => {
      this.startDate = dayjs(this.maxDate)
        .subtract(this.dayPeriod, 'day')
        .format('YYYY-MM-DD')
    })
  },
  destroyed() {
    window.removeEventListener('resize', this.handleResize)
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
