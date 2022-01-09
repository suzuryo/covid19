<template>
  <cards-lazy-row :rows="rows" />
</template>

<script lang="ts">
import Vue from 'vue'

import CardsLazyRow from '@/components/index/_shared/CardsLazyRow.vue'

const ConfirmedCasesDetailsCard = () =>
  import('@/components/index/CardsFeatured/ConfirmedCasesDetails/Card.vue')
const HospitalCapacityCard = () =>
  import('@/components/index/CardsFeatured/HospitalCapacity/Card.vue')
const HotelCapacityCard = () =>
  import('@/components/index/CardsFeatured/HotelCapacity/Card.vue')
const MonitoringConfirmedCasesNumberPer100kCard = () =>
  import(
    '@/components/index/CardsFeatured/MonitoringConfirmedCasesNumberPer100k/Card.vue'
  )
const StageCard = () =>
  import('@/components/index/CardsFeatured/Stage/Card.vue')
const WeeklyMapCard = () =>
  import('@/components/index/CardsFeatured/WeeklyMap/Card.vue')

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
