<template>
  <data-view :title="infoTitles[0]" :title-id="titleId" :date="date">
    <p :class="$style.lead">
      「新たなレベル分類の考え方」で示された「予測ツール」によるシミュレーション結果
    </p>
    <table :class="$style.table">
      <thead>
        <tr>
          <th colspan="2" :class="$style.headers">
            酸素投与を要する人の予測値（重症者を含む）
          </th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <th>1週間後</th>
          <td :class="$style.simulation">
            {{ healthBurden.酸素需要を要する人.week1 }}
          </td>
        </tr>
        <tr>
          <th>2週間後</th>
          <td :class="$style.simulation">
            {{ healthBurden.酸素需要を要する人.week2 }}
          </td>
        </tr>
        <tr>
          <th>3週間後</th>
          <td :class="$style.simulation">
            {{ healthBurden.酸素需要を要する人.week3 }}
          </td>
        </tr>
      </tbody>
    </table>
    <table :class="$style.table">
      <thead>
        <tr>
          <th colspan="2" :class="$style.headers">
            必要と思われる重症病床の確保数の予測値
          </th>
          <th :class="[$style.headers, $style.real]">実際の確保数</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <th>1週間後</th>
          <td :class="$style.simulation">
            {{ healthBurden.重症病床を要する人.week1 }}
          </td>
          <td rowspan="3">33</td>
        </tr>
        <tr>
          <th>2週間後</th>
          <td :class="$style.simulation">
            {{ healthBurden.重症病床を要する人.week2 }}
          </td>
        </tr>
        <tr>
          <th>3週間後</th>
          <td :class="$style.simulation">
            {{ healthBurden.重症病床を要する人.week3 }}
          </td>
        </tr>
      </tbody>
    </table>
    <table :class="$style.table">
      <thead>
        <tr>
          <th colspan="2" :class="$style.headers">
            自宅療養や療養施設を積極的に利用した場合、必要と思われる確保病床数の予測値
          </th>
          <th :class="[$style.headers, $style.real]">実際の確保数</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <th>1週間後</th>
          <td :class="$style.simulation">
            {{ healthBurden.自宅療養や療養施設を積極的に利用した場合.week1 }}
          </td>
          <td rowspan="3">400</td>
        </tr>
        <tr>
          <th>2週間後</th>
          <td :class="$style.simulation">
            {{ healthBurden.自宅療養や療養施設を積極的に利用した場合.week2 }}
          </td>
        </tr>
        <tr>
          <th>3週間後</th>
          <td :class="$style.simulation">
            {{ healthBurden.自宅療養や療養施設を積極的に利用した場合.week3 }}
          </td>
        </tr>
      </tbody>
    </table>
    <table :class="$style.table">
      <thead>
        <tr>
          <th colspan="2" :class="$style.headers">
            ハイリスク軽症者や、ハイリスクでなくとも中等症1は基本的に入院させる場合、必要と思われる確保病床数の予測値
          </th>
          <th :class="[$style.headers, $style.real]">実際の確保数</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <th>1週間後</th>
          <td :class="$style.simulation">
            {{ healthBurden.基本的に入院させる場合.week1 }}
          </td>
          <td rowspan="3">400</td>
        </tr>
        <tr>
          <th>2週間後</th>
          <td :class="$style.simulation">
            {{ healthBurden.基本的に入院させる場合.week2 }}
          </td>
        </tr>
        <tr>
          <th>3週間後</th>
          <td :class="$style.simulation">
            {{ healthBurden.基本的に入院させる場合.week3 }}
          </td>
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

import AppLink from '@/components/_shared/AppLink.vue'
import DataView from '@/components/index/_shared/DataView.vue'
import NotesExpansionPanel from '@/components/index/_shared/DataView/NotesExpansionPanel.vue'
import DataViewDataSetPanel from '@/components/index/_shared/DataViewDataSetPanel.vue'

type Data = {}
type Methods = {}
type Computed = {}
type Props = {
  date: string
  infoTitles: string[]
  titleId: string
  healthBurden: any
}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  Data,
  Methods,
  Computed,
  Props
> = {
  components: {
    AppLink,
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
      required: true,
      default: () => [],
    },
    titleId: {
      type: String,
      required: true,
      default: '',
    },
    healthBurden: {
      type: Object,
      required: true,
    },
  },
}

export default Vue.extend(options)
</script>

<style lang="scss" module>
.lead {
  @include font-size(13);
}
.table {
  margin: 5px auto;
  border-collapse: collapse;
  width: 90%;
  margin-bottom: 10px;
  @include font-size(13);
  tr {
    th,
    td {
      font-weight: normal;
      padding: 5px 10px;
      word-break: break-word;
      border: 1px solid #333;
      text-align: center;
    }
    .simulation {
      width: 20%;
    }
    .real {
      width: 20%;
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
</style>
