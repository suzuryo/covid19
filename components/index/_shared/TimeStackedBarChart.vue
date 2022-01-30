<template>
  <data-view :title="title" :title-id="titleId" :date="date">
    <template #description>
      <slot name="description" />
    </template>
    <template #button>
      <data-selector
        v-model="dataKind"
        :target-id="chartId"
        :style="{ display: canvas ? 'inline-block' : 'none' }"
      />
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
        :display-legends="displayLegends"
        :height="240"
        :width="300"
        :min="startDate"
        :max="endDate"
        :y-axis-max="scaledTicksYAxisMax"
        :switch="dataKind"
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
    <template #dataTable>
      <client-only>
        <data-view-table :headers="tableHeaders" :items="tableData" />
      </client-only>
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
import { ChartOptions, ChartTooltipItem } from 'chart.js'
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

extend(isBetween)

type Data = {
  dataKind: 'transition' | 'cumulative'
  canvas: boolean
  displayLegends: boolean[]
  colors: SurfaceStyle[]
  isSmall: boolean
  startDate: string
  endDate: string
}

type Methods = {
  sum: (array: number[]) => number
  cumulative: (array: number[]) => number[]
  pickLastNumber: (chartDataArray: number[][]) => number[]
  cumulativeSum: (chartDataArray: number[][]) => number[]
  eachArraySum: (chartDataArray: number[][]) => number[]
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
  displayOption: ChartOptions
  scaledTicksYAxisMax: number
  tableHeaders: TableHeader[]
  tableData: TableItem[]
  startDateIndex: number
  endDateIndex: number
}

type Props = {
  title: string
  titleId: string
  chartId: string
  chartData: number[][]
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
    this.dataKind =
      this.$route.query.embed && this.$route.query.dataKind === 'cumulative'
        ? 'cumulative'
        : 'transition'
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
      default: 'time-stacked-bar-chart',
    },
    chartData: {
      type: Array,
      required: false,
      default: () => [],
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
  data() {
    return {
      dataKind: 'transition',
      displayLegends: [true, true],
      colors: getGraphSeriesStyle(2),
      canvas: true,
      isSmall: false,
      startDate: '2020-01-01',
      endDate: dayjs().format('YYYY-MM-DD'),
    }
  },
  computed: {
    minDate() {
      return dayjs(this.labels[0]).format('YYYY-MM-DD')
    },
    maxDate() {
      return dayjs(this.labels[this.labels.length - 1]).format('YYYY-MM-DD')
    },
    displayInfo() {
      const lastDay = this.labels[this.labels.length - 1]
      const date = this.$d(getDayjsObject(lastDay).toDate(), 'dateWithoutYear')

      if (this.dataKind === 'transition') {
        return {
          lText: this.sum(this.pickLastNumber(this.chartData)).toLocaleString(),
          sText: `${this.$t('{date}の合計', { date })}`,
          unit: this.unit,
        }
      }
      return {
        lText: this.sum(this.cumulativeSum(this.chartData)).toLocaleString(),
        sText: `${this.$t('{date}の合計', { date })}`,
        unit: this.unit,
      }
    },
    displayData() {
      const graphSeries = getGraphSeriesStyle(this.chartData.length)
      const rangeDate = this.labels.filter((item) => {
        const date = dayjs(item)
        return date.isBetween(this.startDate, this.endDate, null, '[]')
      })
      if (this.dataKind === 'transition') {
        return {
          labels: rangeDate,
          datasets: this.chartData.map((item, index) => {
            return {
              label: this.items[index],
              data: item.slice(this.startDateIndex, this.endDateIndex + 1),
              backgroundColor: graphSeries[index].fillColor,
              borderColor: graphSeries[index].strokeColor,
              borderWidth: 1,
            }
          }),
        }
      }
      return {
        labels: rangeDate,
        datasets: this.chartData.map((item, index) => {
          return {
            label: this.items[index],
            data: this.cumulative(item).slice(
              this.startDateIndex,
              this.endDateIndex + 1
            ),
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
        ...(this.tableLabels as string[])
          .reduce((arr, text) => {
            arr.push(
              ...[this.$t('日別'), this.$t('Common.累計')].map(
                (label) => `${text} (${label})`
              )
            )
            return arr
          }, [] as string[])
          .map((text, i) => {
            return {
              text,
              value: String(i),
              align: 'end',
              width: this.isSmall ? '6em' : 'auto',
            }
          }),
      ]
    },
    tableData() {
      return this.labels
        .map((label, i) => {
          return Object.assign(
            { text: label },
            ...this.tableHeaders.map((_, j) => {
              const index = j < 2 ? 0 : 1
              const transition = this.chartData[index]
              const cumulative = this.cumulative(transition)
              return {
                [j]:
                  j % 2 === 0
                    ? transition[i].toLocaleString()
                    : cumulative[i].toLocaleString(),
              }
            })
          )
        })
        .sort((a, b) => dayjs(a.text).unix() - dayjs(b.text).unix())
        .reverse()
    },
    displayOption() {
      const unit = this.unit
      const data = this.chartData
      const sumArray = this.eachArraySum(data)
      const cumulativeData = data.map((item) => {
        return this.cumulative(item)
      })
      const cumulativeSumArray = this.eachArraySum(cumulativeData)
      const searchIndex = (obj: ChartTooltipItem) => {
        return this.labels.findIndex((v) => {
          return v === obj.label
        })
      }
      const options: ChartOptions = {
        tooltips: {
          displayColors: false,
          callbacks: {
            label: (tooltipItem) => {
              let casesTotal, cases, label
              const itemIndex = searchIndex(tooltipItem)
              if (this.dataKind === 'transition') {
                casesTotal = sumArray[itemIndex].toLocaleString()
                cases =
                  data[tooltipItem.datasetIndex!][
                    tooltipItem.index!
                  ].toLocaleString()
              } else {
                casesTotal =
                  cumulativeSumArray[tooltipItem.index!].toLocaleString()
                cases =
                  cumulativeData[tooltipItem.datasetIndex!][
                    itemIndex
                  ].toLocaleString()
              }

              label = `${
                this.dataLabels[tooltipItem.datasetIndex!]
              } : ${cases} ${unit}`
              if (this.dataKind === 'cumulative') {
                label = `${label} (${this.$t('合計')}: ${casesTotal} ${unit})`
              }
              return label
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
              display: false,
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
      const data = this.displayData.datasets
      const max = Array.from(data[0].data.keys())
        .map((i) => data[0].data[i] + data[1].data[i])
        .reduce((a, b) => Math.max(a, b), 0)
      const digits = String(max).length
      const base = 10 ** (digits - 1)
      return Math.ceil(max / base) * base
    },
    startDateIndex() {
      const searchIndex = this.labels.findIndex((item) => {
        const date = dayjs(item).format('YYYY-MM-DD')
        return date === this.startDate
      })
      return searchIndex === -1 ? 0 : searchIndex
    },
    endDateIndex() {
      const searchIndex = this.labels.findIndex((item) => {
        const date = dayjs(item).format('YYYY-MM-DD')
        return date === this.endDate
      })
      return searchIndex === -1 ? this.labels.length - 1 : searchIndex
    },
  },
  methods: {
    onClickLegend(i) {
      this.displayLegends[i] = !this.displayLegends[i]
      this.displayLegends = this.displayLegends.slice()
    },
    cumulative(array: number[]): number[] {
      const cumulativeArray: number[] = []
      let patSum = 0
      array.forEach((d) => {
        patSum += d
        cumulativeArray.push(patSum)
      })
      return cumulativeArray
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
    cumulativeSum(chartDataArray: number[][]) {
      return chartDataArray.map((array) => {
        return array.reduce((acc, cur) => {
          return acc + cur
        })
      })
    },
    eachArraySum(chartDataArray: number[][]) {
      const sumArray: number[] = []
      for (let i = 0; i < chartDataArray[0].length; i++) {
        sumArray.push(chartDataArray[0][i] + chartDataArray[1][i])
      }
      return sumArray
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
