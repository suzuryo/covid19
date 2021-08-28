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
              background: colors.rgbAt(i / chartData.length),
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
    <scrollable-chart v-show="canvas" :display-data="displayData">
      <template #chart="{ chartWidth }">
        <line-chart
          :ref="'lineChart'"
          :chart-id="chartId"
          :chart-data="displayData"
          :options="displayOption"
          :display-legends="displayLegends"
          :height="240"
          :width="chartWidth"
        />
      </template>
      <template #sticky-chart>
        <line-chart
          class="sticky-legend"
          :chart-id="`${chartId}-header-right`"
          :chart-data="displayDataHeader"
          :options="displayOptionHeader"
          :display-legends="displayLegends"
          :plugins="yAxesBgPlugin"
          :height="240"
        />
      </template>
    </scrollable-chart>
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
import { Chart } from 'chart.js'
import dayjs from 'dayjs'
import tinygradient from 'tinygradient'
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'
import { TranslateResult } from 'vue-i18n'

import DataView from '@/components/index/_shared/DataView.vue'
import NotesExpansionPanel from '@/components/index/_shared/DataView/NotesExpansionPanel.vue'
import DataViewDataSetPanel from '@/components/index/_shared/DataViewDataSetPanel.vue'
import DataViewTable, {
  TableHeader,
  TableItem,
} from '@/components/index/_shared/DataViewTable.vue'
import ScrollableChart from '@/components/index/_shared/ScrollableChart.vue'
import { DisplayData, yAxesBgPlugin } from '@/plugins/vue-chart'
import { getNumberToLocaleStringFunction } from '@/utils/monitoringStatusValueFormatters'

type Data = {
  displayLegends: boolean[]
  colors: tinygradient.Instance
  canvas: boolean
}
type Methods = {
  onClickLegend: (i: number) => void
}

type Computed = {
  displayData: DisplayData
  displayOption: Chart.ChartOptions
  displayDataHeader: DisplayData
  displayOptionHeader: Chart.ChartOptions
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
  },
  components: {
    DataView,
    DataViewTable,
    DataViewDataSetPanel,
    NotesExpansionPanel,
    ScrollableChart,
  },
  props: {
    title: {
      type: String,
      default: '',
    },
    titleId: {
      type: String,
      required: false,
      default: 'age',
    },
    infoTitles: {
      type: Array,
      required: false,
      default: () => [],
    },
    chartId: {
      type: String,
      default: 'age-chart',
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
  },
  data() {
    const colors = tinygradient(
      '#7838FF',
      '#4DDFF7',
      '#CDF24E',
      '#FFBA4A',
      '#E6393F'
    )
    return {
      displayLegends: [
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
      ],
      colors,
      canvas: true,
      yAxesBgPlugin,
    }
  },
  computed: {
    displayData() {
      return {
        labels: this.labels,
        datasets: this.chartData.map((_, i) => {
          return {
            type: 'line',
            label: this.dataLabels[i],
            data: this.chartData[i],
            pointRadius: 0,
            borderColor: this.colors.rgbAt(i / this.chartData.length),
            borderWidth: 1.1,
            fill: false,
            order: i,
            lineTension: 0.2,
          }
        }),
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
      const options: Chart.ChartOptions = {
        tooltips: {
          displayColors: false,
          callbacks: {
            label: (tooltipItem) => {
              const cases = this.getFormatter(tooltipItem.datasetIndex!)(
                parseFloat(tooltipItem.value!)
              )
              return `${this.dataLabels[tooltipItem.datasetIndex!]} : ${cases}`
            },
            title(tooltipItem, data) {
              const date = data.labels![tooltipItem[0].index!].toString()
              return dayjs(date).format('M/D')
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
                fontColor: '#808080',
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
              id: 'age',
              position: 'left',
              gridLines: {
                display: true,
                drawOnChartArea: true,
                color: '#E5E5E5', // #E5E5E5
              },
              ticks: {
                suggestedMin: 0,
                maxTicksLimit: 8,
                fontColor: '#808080', // #808080
                min: 0,
                max: this.scaledTicksYAxisMax,
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
    displayDataHeader() {
      return {
        labels: ['2020-01-01'],
        datasets: (this.dataLabels as string[]).map((_) => ({
          data: [],
          backgroundColor: 'transparent',
          borderWidth: 0,
        })),
      }
    },
    displayOptionHeader() {
      const options: Chart.ChartOptions = {
        maintainAspectRatio: false,
        legend: {
          display: false,
        },
        tooltips: { enabled: false },
        scales: {
          xAxes: [
            {
              display: false, // day軸は非表示にしたいが、削除すると#2384のように見切れるので残す workaround
              id: 'day',
            },
            {
              id: 'month',
              stacked: true,
              gridLines: {
                drawOnChartArea: false,
                drawTicks: false, // true -> false
                drawBorder: false,
                tickMarkLength: 10,
              },
              ticks: {
                fontSize: 11,
                fontColor: 'transparent', // #808080
                padding: 13, // 3 + 10(tickMarkLength)
                fontStyle: 'bold',
              },
              type: 'time',
              time: {
                unit: 'month',
              },
            },
          ],
          yAxes: [
            {
              type: 'linear',
              position: 'left',
              gridLines: {
                display: true,
                drawOnChartArea: false,
                color: '#E5E5E5', // #E5E5E5
              },
              ticks: {
                suggestedMin: 0,
                maxTicksLimit: 8,
                fontColor: '#808080', // #808080
                min: 0,
                max: this.scaledTicksYAxisMax,
              },
            },
          ],
        },
        animation: { duration: 0 },
      }
      return options
    },
    scaledTicksYAxisMax() {
      return this.chartData.reduce((max, data) => {
        return Math.max(max, ...data.map((a) => Math.ceil(a)))
      }, 0)
    },
  },
  methods: {
    onClickLegend(i) {
      this.displayLegends[i] = !this.displayLegends[i]
      this.displayLegends = this.displayLegends.slice()
    },
  },
  mounted() {
    const lineChart = this.$refs.lineChart as Vue
    const lineElement = lineChart.$el
    const canvas = lineElement.querySelector('canvas')
    const labelledbyId = `${this.titleId}-graph`

    if (canvas) {
      canvas.setAttribute('role', 'img')
      canvas.setAttribute('aria-labelledby', labelledbyId)
    }
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
      margin: 0 2px;
      div {
        height: 12px;
        margin: 2px 0;
        width: 20px;
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
