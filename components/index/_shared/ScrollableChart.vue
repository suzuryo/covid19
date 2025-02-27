<template>
  <div ref="chartContainer" class="LegendStickyChart">
    <div ref="scrollable" class="scrollable" tabindex="0">
      <div :style="{ width: `${chartWidth}px` }">
        <slot name="chart" :chart-width="chartWidth" />
      </div>
    </div>
    <slot name="sticky-chart" />
  </div>
</template>

<script lang="ts">
import type { PropType } from 'vue'
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'

import { DisplayData } from '@/plugins/vue-chart'
import { EventBus, TOGGLE_EVENT } from '@/utils/tab-event-bus'

type Data = {
  chartWidth: number
  timerId: number
}
type Methods = {
  adjustChartWidth: () => void
  calcChartWidth: (containerWidth: number, labelCount: number) => number
  scrollRightSide: () => void
  handleResize: () => void
}
type Computed = {
  labelCount: number
}
type Props = {
  displayData: DisplayData
}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  Data,
  Methods,
  Computed,
  Props
> = {
  props: {
    displayData: {
      type: Object as PropType<DisplayData>,
      required: true,
    },
  },
  data() {
    return {
      chartWidth: 300,
      timerId: 0,
    }
  },
  watch: {
    displayData() {
      this.scrollRightSide()
    },
  },
  computed: {
    labelCount() {
      return this.displayData.labels?.length || 0
    },
  },
  methods: {
    adjustChartWidth() {
      const container = this.$refs.chartContainer as HTMLElement
      if (!container || container.clientWidth === 0) return
      const containerWidth = container.clientWidth
      this.chartWidth = this.calcChartWidth(containerWidth, this.labelCount)
    },
    calcChartWidth(containerWidth, labelCount) {
      const yaxisWidth = 38
      const barWidth = this.$nuxt.$vuetify.breakpoint.smAndDown ? 4 : 6
      const calcWidth = barWidth * labelCount + yaxisWidth
      return Math.max(calcWidth, containerWidth)
    },
    scrollRightSide() {
      const scrollable = this.$refs.scrollable as HTMLElement
      if (!scrollable) return
      scrollable.scrollLeft = this.chartWidth
    },
    handleResize() {
      clearTimeout(this.timerId)
      this.timerId = window.setTimeout(this.adjustChartWidth, 500)
    },
  },
  mounted() {
    this.adjustChartWidth()
    this.$on('update-width', this.scrollRightSide)
    window.addEventListener('resize', this.handleResize)
    // タブ切り替え時にグラフ幅を再計算
    EventBus.$on(TOGGLE_EVENT, () => setTimeout(() => this.adjustChartWidth()))
    window.matchMedia('print').addEventListener('change', () => {
      this.scrollRightSide()
    })
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
    EventBus.$off(TOGGLE_EVENT)
    window.matchMedia('print').removeEventListener('change', () => {
      this.scrollRightSide()
    })
  },
}

export default options
</script>

<style lang="scss" scoped>
.LegendStickyChart {
  margin: 16px 0;
  position: relative;
  overflow: hidden;

  .scrollable {
    overflow-x: scroll;
  }

  .sticky-legend {
    position: absolute;
    top: 0;
    pointer-events: none;
    width: 100%;
  }
}
</style>
