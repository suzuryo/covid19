<template>
  <data-view :title="title" :title-id="titleId" :date="date">
    <div class="Beds">
      <div
        v-for="bed in bedSummary.beds"
        :key="bed"
        :class="bedInUse(bed)"
        :title="bed + 1"
      >
        <span
          v-if="
            bed % 50 === 50 - 1 ||
            bed === 85 - 1 ||
            bed === 85 + 162 - 1 ||
            bed === 85 + 162 + 130 - 1
          "
        >
          {{ bed + 1 }}
        </span>
      </div>
    </div>
    <div class="legend1">
      <div>
        <span class="Bed inuse" />
        {{ $t('HotelCapacityCard.療養中') }}
      </div>
      <div>
        <span class="Bed" />
        {{ $t('HotelCapacityCard.空き') }}
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
        :title="$t('HotelCapacityCard.title')"
        :l-text-before="$t('残り')"
        :l-text="`${remaining}`"
        :unit="$t('室')"
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
    const remaining = 85 + 162 + 130 - this.bedSummary.hotel
    return {
      remaining,
    }
  },
  methods: {
    bedInUse(bed: number): string {
      const classes = ['Bed']

      // ベッド使用中
      if (bed < this.bedSummary.hotel) {
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
  > span {
    display: inline-block;
    line-height: $bed_size - 2px;
    height: $bed_size - 2px;
    width: $bed_size - 2px;
    text-align: center;
    font-family: 'Helvetica', 'Arial', sans-serif;
    letter-spacing: 0;
    @include font-size(7);
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
