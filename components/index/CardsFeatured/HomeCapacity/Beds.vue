<template>
  <data-view :title="title" :title-id="titleId" :date="date">
    <div class="Beds">
      <div
        v-for="bed in bedSummary.beds"
        :key="bed"
        :class="bedInUse(bed)"
        :title="bed + 1"
      >
        <span v-if="bed === bedSummary.home - 1 || bed % 50 === 50 - 1">
          {{ bed + 1 }}
        </span>
      </div>
    </div>
    <div class="legend1">
      <div>
        <span class="Bed inuse" />
        {{ $t('HomeCapacityCard.療養中') }}
      </div>
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
        :title="$t('HomeCapacityCard.title')"
        :l-text-before="$t('Common.現在')"
        :l-text="`${remaining}`"
        :unit="$t('Common.人')"
        :card-path="`/cards/${titleId}/`"
      />
    </template>
  </data-view>
</template>

<script lang="ts">
import Vue from 'vue'

import DataView from '@/components/index/_shared/DataView.vue'
import NotesExpansionPanel from '@/components/index/_shared/DataView/NotesExpansionPanel.vue'
import DataViewDataSetPanel from '@/components/index/_shared/DataViewDataSetPanel.vue'

export default Vue.extend({
  components: {
    DataView,
    DataViewDataSetPanel,
    NotesExpansionPanel,
  },
  props: {
    title: {
      type: String,
      default: '',
    },
    titleId: {
      type: String,
      default: '',
    },
    date: {
      type: String,
      default: '',
    },
    bedSummary: {
      type: Object,
      default: () => {},
    },
  },
  data() {
    const remaining = this.bedSummary.home
    return {
      remaining,
    }
  },
  methods: {
    bedInUse(bed: number): string {
      const classes = ['Bed']

      // ベッド使用中
      if (bed < this.bedSummary.home) {
        classes.push('inuse')
      }

      return classes.join(' ')
    },
  },
})
</script>

<style lang="scss" scoped>
.Beds {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  flex-wrap: wrap;
}
$bed_size: 16px;
.Bed {
  display: inline-block;
  vertical-align: middle;
  width: $bed_size;
  height: $bed_size;
  margin-right: 3px;
  margin-bottom: 3px;
  border: 1px solid #aaa;
  background-color: #fff;
  @include font-size(10);
  > span {
    display: inline-block;
    line-height: $bed_size;
    height: $bed_size;
    width: $bed_size;
    text-align: center;
    font-family: 'Helvetica', 'Arial', sans-serif;
    font-weight: 600;
    color: #777;
    letter-spacing: 0;
    word-wrap: normal;
    transform: scale(0.8) translate(-10%);
    @include font-size(10);
  }
  &.inuse {
    background-color: #fce5da;
  }
}
.legend1 {
  display: flex;
  @include font-size(12);
  > div {
    margin: 20px 20px 20px 0;
    flex-wrap: wrap;
  }
}
</style>
