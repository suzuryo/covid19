<template>
  <cards-lazy-row :rows="rows" />
</template>

<script lang="ts">
import Vue from 'vue'

import CardsLazyRow from '@/components/index/_shared/CardsLazyRow.vue'
import ConfirmedCasesAreaChart from '@/components/index/CardsFeatured/ConfirmedCasesArea/Card.vue'
import ConfirmedCasesDetailsCard from '@/components/index/CardsFeatured/ConfirmedCasesDetails/Card.vue'
import HealthBurdenCard from '@/components/index/CardsFeatured/HealthBurden/Card.vue'
import HomeCapacityCard from '@/components/index/CardsFeatured/HomeCapacity/Card.vue'
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
        [WeeklyMapCard, ConfirmedCasesAreaChart],
        [ConfirmedCasesDetailsCard, MonitoringConfirmedCasesNumberPer100kCard],
        [StageCard, HealthBurdenCard],
        [HospitalCapacityCard, HotelCapacityCard],
        [HomeCapacityCard],
      ],
    }
  },
})
</script>
