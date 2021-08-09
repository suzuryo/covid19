<template>
  <data-view :title="infoTitles[0]" :title-id="titleId" :date="date">
    <table :class="$style.table">
      <thead>
        <tr>
          <th colspan="4" scope="row" :class="$style.headers">
            {{ $t('StageCard.指標') }}
          </th>
          <th scope="row" :class="$style.headers">
            {{ $t('StageCard.単位') }}
          </th>
          <th scope="row" :class="[$style.headers, 'iwate']">
            {{ $t('Common.岩手県') }}
          </th>
          <th scope="row" :class="[$style.headers, $style.headerStage3]">
            {{ $t('Common.ステージ3') }}
          </th>
          <th scope="row" :class="[$style.headers, $style.headerStage4]">
            {{ $t('Common.ステージ4') }}
          </th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <th id="sh1" scope="col" rowspan="4">
            {{ $t('StageCard.医療提供体制の負荷') }}
          </th>
          <th id="sh3" headers="sh1" scope="col" rowspan="3">
            {{ $t('StageCard.医療のひっ迫具合') }}
          </th>
          <th id="sh4" headers="sh1 sh3" scope="col" rowspan="2">
            {{ $t('StageCard.入院医療') }}
          </th>
          <th headers="sh1 sh4 sh4" scope="col">
            {{ $t('StageCard.確保病床の使用率') }}
          </th>
          <td>%</td>
          <td :class="stage3stage4(tableData[0], 20, 50, 'gte')">
            {{ getFormatter(1)(tableData[0]) }}
          </td>
          <td :class="$style.indexStage3">20</td>
          <td :class="$style.indexStage4">50</td>
        </tr>
        <tr>
          <th headers="sh1 sh3 sh4" scope="col">
            {{ $t('StageCard.入院率') }}
          </th>
          <td>%</td>
          <td
            :class="
              tableData[3] < 10
                ? 'iwate'
                : stage3stage4(tableData[1], 40, 25, 'lte')
            "
          >
            {{ tableData[1] === 99999 ? '-' : getFormatter(1)(tableData[1]) }}
          </td>
          <td :class="$style.indexStage3">40</td>
          <td :class="$style.indexStage4">25</td>
        </tr>
        <tr>
          <th id="sh1 sh3 sh5" scope="col">
            {{ $t('StageCard.重症者用病床') }}
          </th>
          <th headers="sh1 sh3 sh5" scope="col">
            {{ $t('StageCard.確保病床の使用率') }}
          </th>
          <td>%</td>
          <td :class="stage3stage4(tableData[2], 20, 50, 'gte')">
            {{ getFormatter(1)(tableData[2]) }}
          </td>
          <td :class="$style.indexStage3">20</td>
          <td :class="$style.indexStage4">50</td>
        </tr>
        <tr>
          <th headers="sh1" scope="col" colspan="3">
            {{ $t('StageCard.療養者数(対人口10万人)') }}
          </th>
          <td>{{ $t('Common.人') }}</td>
          <td :class="stage3stage4(tableData[3], 20, 30, 'gte')">
            {{ getFormatter(1)(tableData[3]) }}
          </td>
          <td :class="$style.indexStage3">20</td>
          <td :class="$style.indexStage4">30</td>
        </tr>
        <tr>
          <th id="sh2" scope="col" rowspan="3">
            {{ $t('StageCard.感染の状況') }}
          </th>
          <th headers="sh2" scope="col" colspan="3">
            {{ $t('StageCard.PCR陽性率(直近1週間)') }}
          </th>
          <td>%</td>
          <td :class="stage3stage4(tableData[4], 5, 10, 'gte')">
            {{ tableData[4] === 99999 ? '-' : getFormatter(1)(tableData[4]) }}
          </td>
          <td :class="$style.indexStage3">5</td>
          <td :class="$style.indexStage4">10</td>
        </tr>
        <tr>
          <th headers="sh2" scope="col" colspan="3">
            {{ $t('StageCard.新規陽性者数(直近1週間・対人口10万人)') }}
          </th>
          <td>{{ $t('Common.人') }}</td>
          <td :class="stage3stage4(tableData[5], 15, 25, 'gte')">
            {{ getFormatter(1)(tableData[5]) }}
          </td>
          <td :class="$style.indexStage3">15</td>
          <td :class="$style.indexStage4">25</td>
        </tr>
        <tr>
          <th headers="sh2" scope="col" colspan="3">
            {{ $t('StageCard.感染経路不明割合(直近1週間)') }}
          </th>
          <td>%</td>
          <td :class="stage3stage4(tableData[6], 50, 50, 'gte')">
            {{ tableData[6] === 99999 ? '-' : getFormatter(1)(tableData[6]) }}
          </td>
          <td :class="$style.indexStage3">50</td>
          <td :class="$style.indexStage4">50</td>
        </tr>
      </tbody>
    </table>
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
        :title="infoTitles[0]"
        :card-path="`/cards/${titleId}`"
      />
    </template>
  </data-view>
</template>

<script lang="ts">
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'

import DataView from '@/components/index/_shared/DataView.vue'
import NotesExpansionPanel from '@/components/index/_shared/DataView/NotesExpansionPanel.vue'
import DataViewDataSetPanel from '@/components/index/_shared/DataViewDataSetPanel.vue'
import { getNumberToFixedFunction } from '@/utils/monitoringStatusValueFormatters'

type Data = {}
type Methods = {
  stage3stage4: (
    current: number,
    stage3: number,
    stage4: number,
    gl: string
  ) => string[]
}
type Computed = {}

type Props = {
  date: string
  infoTitles: string[]
  titleId: string
  getFormatter: Function
  tableData: number[]
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
    DataViewDataSetPanel,
    NotesExpansionPanel,
  },
  props: {
    date: {
      type: String,
      required: true,
      default: '',
    },
    infoTitles: {
      type: Array,
      required: false,
      default: () => [],
    },
    titleId: {
      type: String,
      required: true,
      default: '',
    },
    getFormatter: {
      type: Function,
      required: false,
      default: (_: number) => getNumberToFixedFunction(1),
    },
    tableData: {
      type: Array,
      required: true,
      default: [0, 0, 0, 0, 0, 0, 0],
    },
  },
  methods: {
    stage3stage4(current: number, stage3: number, stage4: number, gl: string) {
      if (current === 99999) {
        return ['iwate']
      }
      const stage = ['iwate']
      // gteは以上、lteは以下
      if (gl === 'gte') {
        if (current >= stage4) {
          stage.push('stage4')
        } else if (current >= stage3) {
          stage.push('stage3')
        }
      }
      if (gl === 'lte') {
        if (current <= stage4) {
          stage.push('stage4')
        } else if (current <= stage3) {
          stage.push('stage3')
        }
      }
      return stage
    },
  },
}

export default Vue.extend(options)
</script>

<style lang="scss" module>
.table {
  margin: 5px auto;
  border-collapse: collapse;
  @include font-size(13);
  tr {
    th,
    td {
      font-weight: normal;
      padding: 10px;
      word-break: break-word;
      border: 1px solid #333;
    }
    td {
      text-align: center;
    }
  }
  @include lessThan($small) {
    tr {
      th,
      td {
        padding: 5px;
      }
    }
    @include font-size(12);
  }
}
.headers {
  background-color: rgb(253, 233, 217);
}
.headerStage3 {
  background-color: rgb(255, 234, 156);
}
.headerStage4 {
  background-color: rgb(255, 199, 205);
}
.indexStage3 {
  color: rgb(255, 105, 51);
}
.indexStage4 {
  color: rgb(255, 1, 0);
}
</style>

<style lang="scss">
#StageCard {
  th,
  td {
    &.iwate {
      width: 6em;
      font-weight: bold;
    }
    &.stage3 {
      color: rgb(255, 105, 51);
      background-color: rgb(255, 234, 156);
    }
    &.stage4 {
      color: rgb(255, 1, 0);
      background-color: rgb(255, 199, 205);
    }
  }
}
</style>
