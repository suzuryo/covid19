<template>
  <v-tabs v-model="tab" hide-slider>
    <v-tab
      v-for="(item, i) in items"
      :id="`cardTab-${i}`"
      :key="i"
      v-ripple="false"
      :to="{ path: localePath(item.path) }"
      nuxt
      exact
      @click="change"
    >
      {{ item.label }}
    </v-tab>
    <v-tabs-items v-model="tab" touchless>
      <v-tab-item
        v-for="(item, i) in items"
        :key="i"
        :value="localePath(item.path)"
      >
        <lazy-component :is="item.component" />
      </v-tab-item>
    </v-tabs-items>
  </v-tabs>
</template>

<script lang="ts">
import Vue from 'vue'

import CardsFeatured from '@/components/index/CardsFeatured.vue'
import CardsMonitoring from '@/components/index/CardsMonitoring.vue'
import CardsReference from '@/components/index/CardsReference.vue'
import { EventBus, TOGGLE_EVENT } from '@/utils/tab-event-bus'

export default Vue.extend({
  components: {
    CardsFeatured,
    CardsMonitoring,
    CardsReference,
  },
  data() {
    return {
      tab: null,
      items: [
        {
          label: this.$t('Common.現在の状況'),
          component: CardsFeatured,
          path: '/',
        },
        {
          label: this.$vuetify.breakpoint.smAndDown
            ? this.$t('Common.モニタリング')
            : this.$t('Common.モニタリング項目'),
          component: CardsMonitoring,
          path: '/monitoring',
        },
        {
          label: this.$vuetify.breakpoint.smAndDown
            ? this.$t('Common.参考資料')
            : this.$t('Common.お知らせ・参考資料'),
          component: CardsReference,
          path: '/reference/',
        },
      ],
    }
  },
  methods: {
    change() {
      EventBus.$emit(TOGGLE_EVENT)
    },
  },
})
</script>

<style lang="scss">
.v-tabs {
  min-height: 100vh;
}
</style>
