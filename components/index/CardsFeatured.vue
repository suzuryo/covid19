<template>
  <cards-lazy-row :rows="rows" />
</template>

<script lang="ts">
import Vue from 'vue'

import CardsLazyRow from '@/components/index/_shared/CardsLazyRow.vue'
import ConfirmedCasesDetailsCard from '@/components/index/CardsFeatured/ConfirmedCasesDetails/Card.vue'
import HospitalCapacityCard from '@/components/index/CardsFeatured/HospitalCapacity/Card.vue'
import HotelCapacityCard from '@/components/index/CardsFeatured/HotelCapacity/Card.vue'
import MonitoringConfirmedCasesNumberPer100kCard from '@/components/index/CardsFeatured/MonitoringConfirmedCasesNumberPer100k/Card.vue'
import StageCard from '@/components/index/CardsFeatured/Stage/Card.vue'
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
