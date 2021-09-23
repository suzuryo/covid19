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

import CardsMonitoring from '@/components/index/CardsMonitoring.vue'
import CardsReference from '@/components/index/CardsReference.vue'
import { EventBus, TOGGLE_EVENT } from '@/utils/tab-event-bus'

export default Vue.extend({
  components: {
    CardsMonitoring,
    CardsReference,
  },
  data() {
    return {
      tab: null,
      items: [
        {
          label: this.$t('Common.モニタリング項目'),
          component: CardsMonitoring,
          path: '/',
        },
        {
          label: this.$t('Common.お知らせ・参考資料'),
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
