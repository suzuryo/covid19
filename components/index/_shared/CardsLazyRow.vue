<template>
  <div class="DataBlock">
    <v-lazy
      v-for="(row, i) in rows"
      :key="i"
      v-intersect="handler"
      v-scroll="onScroll"
      :value="actives[i]"
      :options="{ threshold: 0 }"
      min-height="550"
      min-width="50%"
    >
      <card-row v-if="actives[i]">
        <component
          :is="component"
          v-for="(component, j) in row"
          :key="j"
          :md="isSingleRow(row) ? '12' : '6'"
        />
      </card-row>
    </v-lazy>
  </div>
</template>

<script lang="ts">
import Vue, { VueConstructor } from 'vue'

import CardRow from '@/components/index/_shared/CardRow.vue'

type Data = {
  actives: boolean[]
  scroll: boolean
}
type Methods = {
  handler: (
    entries: IntersectionObserverEntry[],
    observer: IntersectionObserver,
    isIntersecting: boolean
  ) => void
  onScroll: () => void
  isSingleRow: (row: VueConstructor) => boolean
}
type Computed = {}
type Props = {
  rows: Vue[][]
}

export default Vue.extend<Data, Methods, Computed, Props>({
  components: {
    CardRow,
  },
  props: {
    rows: {
      type: Array,
      required: true,
    },
  },
  data() {
    return {
      actives: Array.from({ length: this.rows.length }, () => false),
      scroll: false,
    }
  },
  methods: {
    handler(_entries, _observer, isIntersecting) {
      if (!isIntersecting) return
      this.$set(this.actives, this.actives.indexOf(false), true)
    },
    onScroll() {
      if (this.scroll) return
      this.scroll = true
      this.$set(this.actives, 0, true)
      this.$set(this.actives, 1, true)
    },
    isSingleRow(row) {
      return row.length === 1
    },
  },
})
</script>

<style lang="scss" scoped>
.DataBlock {
  margin-top: 20px;

  .DataCard {
    padding: 12px;
    @include lessThan(960) {
      padding: 12px;
      &:nth-child(2n) {
        padding: 0 12px 12px 12px;
      }
    }
  }
}
</style>
