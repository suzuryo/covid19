import { Plugin } from '@nuxt/types'
import Chart, { ChartData, ChartOptions } from 'chart.js'
import type { PropType } from 'vue'
import Vue from 'vue'
// eslint-disable-next-line import/default
import VueChartJs from 'vue-chartjs'

import { useDayjsAdapter } from '@/plugins/chartjs-adapter-dayjs'

type ChartVCData = { chartData: ChartData }
type ChartVCMethod = {
  renderChart(chartData: ChartData, options: ChartOptions): void
}
type ChartVCComputed = unknown
type ChartVCProps = {
  options: Object
  displayLegends: boolean[] | null
  min?: string
  max?: string
  yAxisMax?: number
  switch?: string
}

const VueChartPlugin: Plugin = ({ app }) => {
  useDayjsAdapter(app.i18n)
  createCustomChart()
}

const rgba0 = 'rgba(255,255,255,0)'
const rgba1 = 'rgba(255,255,255,1)'

const createCustomChart = () => {
  const { reactiveProp } = VueChartJs.mixins

  const watchDisplayLegends = function (this: Vue, v?: boolean[] | null) {
    if (v == null) {
      return
    }
    if (v.length === 0) {
      return
    }
    const chart: Chart = this.$data._chart
    v.forEach((display, i) => {
      chart.getDatasetMeta(i).hidden = !display
    })
    chart.update()
  }

  const generalChart = Vue.component<
    ChartVCData,
    ChartVCMethod,
    ChartVCComputed,
    ChartVCProps
  >(
    'GeneralChart', // eslint-disable-next-line vue/one-component-per-file
    {
      mixins: [reactiveProp],
      props: {
        displayLegends: {
          type: Array,
          default: () => null,
        },
        options: {
          type: Object as PropType<ChartOptions>,
          default: () => {},
        },
        min: {
          type: String,
          default: '',
        },
        max: {
          type: String,
          default: '',
        },
        yAxisMax: {
          type: Number,
          default: 0,
        },
        switch: {
          type: String,
          default: '',
        },
      },
      watch: {
        displayLegends: watchDisplayLegends,
        width() {
          setTimeout(() => this.$data._chart.resize())
          this.$parent.$emit('update-width')
        },
        min(value) {
          this.$data._chart.options.scales.xAxes.forEach((v: any) => {
            v.ticks.min = value
          })
          this.$data._chart.update()
        },
        max(value) {
          this.$data._chart.options.scales.xAxes.forEach((v: any) => {
            v.ticks.max = value
          })
          this.$data._chart.update()
        },
        yAxisMax(value) {
          this.$data._chart.options.scales.yAxes.forEach((v: any) => {
            v.ticks.max = value
          })
          this.$data._chart.update()
        },
        switch(newValue, oldValue) {
          if (newValue !== oldValue) {
            this.$data._chart.options.scales.xAxes.forEach((v: any) => {
              v.ticks.min = this.min
            })
            this.$data._chart.options.scales.xAxes.forEach((v: any) => {
              v.ticks.max = this.max
            })
            this.$data._chart.update()
          }
        },
      },
      mounted() {
        this.$nextTick().then(() => {
          this.renderChart(this.chartData, this.options)
        })
      },
    }
  )

  Vue.component<ChartVCData, ChartVCMethod, ChartVCComputed, ChartVCProps>(
    'LineChart', // eslint-disable-next-line vue/one-component-per-file
    {
      mixins: [reactiveProp, VueChartJs.Line, generalChart],
    }
  )

  Vue.component<ChartVCData, ChartVCMethod, ChartVCComputed, ChartVCProps>(
    'Bar', // eslint-disable-next-line vue/one-component-per-file
    {
      mixins: [reactiveProp, VueChartJs.Bar, generalChart],
    }
  )
}

export default VueChartPlugin

export interface DataSets<T = number> extends ChartData {
  data: T[]
}

export interface DataSetsPoint<T = { x: string; y: number }> extends ChartData {
  data: T[]
}

export interface DisplayData<T = number, U = string> {
  labels?: U[]
  datasets: DataSets<T>[]
}
