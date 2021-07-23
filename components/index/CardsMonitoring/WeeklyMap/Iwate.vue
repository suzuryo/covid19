<template>
  <data-view :title="title" :title-id="titleId" :date="date">
    <div id="weekly_map_canvas">
      <svg
        id="weekly_map"
        :class="isOGP"
        viewBox="0 0 962 962"
        preserveAspectRatio="xMinYMin meet"
        @click="resetDataSetPanel"
        @mouseout="resetDataSetPanel"
      >
        <g
          v-for="(item, i) in mapData"
          :key="i"
          :data-count="item.last7days"
          :data-name="item.label"
          :data-area="item.area"
        >
          <path
            stroke="#aaa"
            stroke-width="1px"
            :fill="iwateMapColor(item.last7days)"
            :d="item.d"
            @click="highlightPath($event, item)"
            @mouseover="highlightPath($event, item)"
            @mouseout="unHighlightPath($event)"
          >
            <!-- eslint-disable prettier/prettier -->
            <title>{{ item.label }} ({{ item.area }}) {{ item.last7days }} 例</title>
            <!--eslint-enable-->
          </path>
        </g>
      </svg>
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
    <template #dataSetPanel>
      <data-view-data-set-panel
        :title="title"
        :l-text-before="dataSetPanel.lTextBefore"
        :l-text="dataSetPanel.lText"
        :s-text="dataSetPanel.sText"
        :unit="$t('例')"
        :card-path="`/cards/${titleId}`"
      />
    </template>
  </data-view>
</template>

<script lang="ts">
import tinygradient from 'tinygradient'
import Vue from 'vue'

import DataView from '@/components/index/_shared/DataView.vue'
import NotesExpansionPanel from '@/components/index/_shared/DataView/NotesExpansionPanel.vue'
import DataViewDataSetPanel from '@/components/index/_shared/DataViewDataSetPanel.vue'
import { Cities } from '@/types/weekly-map'

export default Vue.extend({
  components: { DataView, DataViewDataSetPanel, NotesExpansionPanel },
  props: {
    title: {
      required: true,
      type: String,
      default: '',
    },
    titleId: {
      required: true,
      type: String,
      default: '',
    },
    mapData: {
      required: true,
      type: Array,
    },
    date: {
      required: true,
      type: String,
      default: '',
    },
    info: {
      required: true,
      type: Object,
    },
    last7DaysSum: {
      required: true,
      type: Number,
    },
  },
  data() {
    const dataSetPanel = {
      lTextBefore: this.info.lTextBefore,
      lText: this.info.lText,
      sText: this.info.sText,
    }

    return {
      dataSetPanel,
    }
  },
  computed: {
    isOGP() {
      return this.$route.query.ogp === 'true' ? 'isOGP' : ''
    },
  },
  methods: {
    resetDataSetPanel() {
      this.dataSetPanel.lTextBefore = this.$t('岩手県全域')
      this.dataSetPanel.lText = `${this.last7DaysSum}`
      this.dataSetPanel.sText = this.$t('居住地が県外で県内滞在も含む')
      // event.stopPropagation()
    },
    highlightPath(event: MouseEvent, item: Cities) {
      const pathElement = event.currentTarget as SVGPathElement
      const gElement = pathElement.parentNode as SVGGElement
      const svgElement = gElement.parentNode as SVGElement
      pathElement.setAttribute('stroke', '#999')
      pathElement.setAttribute('stroke-width', '3px')
      svgElement.insertBefore(gElement, null)
      // 市町村がクリックされたらその地域の情報を表示
      // DataViewDataSetPanelに渡す
      this.dataSetPanel.lTextBefore = this.$t(`${item.label}`)
      this.dataSetPanel.lText = `${item.last7days}`
      this.dataSetPanel.sText = this.$t('{area}を含む', {
        area: this.$t(`${item.area}`),
      })
      event.stopPropagation()
    },
    unHighlightPath(event: MouseEvent) {
      const pathElement = event.currentTarget as SVGPathElement
      pathElement.setAttribute('stroke', '#aaa')
      pathElement.setAttribute('stroke-width', '1px')
      // event.stopPropagation()
    },
    iwateMapColor(last7day: number) {
      const gradient = tinygradient([
        '#ffffff',
        '#fee0d2',
        '#fcbba1',
        '#fc9272',
        '#fb6a4a',
        '#ef3b2c',
        '#cb181d',
        '#a50f15',
        '#67000d',
      ])

      return gradient.rgbAt(
        last7day / Math.floor((8 * Math.max(this.last7DaysSum, 30)) / 10)
      )
    },
  },
})
</script>

<style lang="scss">
/* svgのレスポンシブ対応 */
#weekly_map_canvas {
  display: inline-block;
  position: relative;
  width: 100%;
  padding-bottom: 100%;
  vertical-align: top;
  overflow: visible;
}
#weekly_map {
  display: inline-block;
  position: absolute;
  top: 0;
  left: 0;
  g {
    cursor: pointer;
  }
  &.isOGP {
    top: -70px;
    left: 25%;
    width: 50%;
    height: 50%;
    margin-left: auto;
    margin-right: auto;
    > g {
      path {
        stroke-width: 3px;
      }
    }
  }
}

@include lessThan($small) {
  #WeeklyMapCard {
    .DataView {
      &-DataSet {
        flex-flow: column;
        &-title {
          margin-bottom: 6px;
        }
        &-DataInfo {
          text-align: right;
          &-date {
            height: 3em;
          }
        }
      }
    }
  }
}
</style>
