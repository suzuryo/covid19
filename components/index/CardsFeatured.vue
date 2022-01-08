<template>
  <cards-lazy-row :rows="rows" />
</template>

<script lang="ts">
import Vue from 'vue'

import CardsLazyRow from '@/components/index/_shared/CardsLazyRow.vue'
import ConfirmedCasesDetailsCard from '@/components/index/CardsFeatured/ConfirmedCasesDetails/Card.vue' // 検査陽性者の状況
import HospitalCapacityCard from '@/components/index/CardsFeatured/HospitalCapacity/Card.vue' // 入院病床の状況
import HotelCapacityCard from '@/components/index/CardsFeatured/HotelCapacity/Card.vue' // 宿泊療養の状況
import MonitoringConfirmedCasesNumberPer100kCard from '@/components/index/CardsFeatured/MonitoringConfirmedCasesNumberPer100k/Card.vue' // 直近1週間の陽性例マップ
import StageCard from '@/components/index/CardsFeatured/Stage/Card.vue' // ステージ判断のための指標
import WeeklyMapCard from '@/components/index/CardsFeatured/WeeklyMap/Card.vue'

export default Vue.extend({
  components: {
    CardsLazyRow,
  },
  data() {
    return {
      rows: [
        [StageCard, ConfirmedCasesDetailsCard],
        [MonitoringConfirmedCasesNumberPer100kCard, WeeklyMapCard],
        [HospitalCapacityCard, HotelCapacityCard],
      ],
    }
  },
})
</script>
