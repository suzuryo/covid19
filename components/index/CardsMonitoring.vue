<template>
  <cards-lazy-row :rows="rows" />
</template>

<script lang="ts">
import Vue from 'vue'

import CardsLazyRow from '@/components/index/_shared/CardsLazyRow.vue'
import ConfirmedCasesNumberCard from '@/components/index/CardsMonitoring/ConfirmedCasesNumber/Card.vue'
import HealthBurdenCard from '@/components/index/CardsMonitoring/HealthBurden/Card.vue'
// import EffectiveReproductionNumberCard from '@/components/index/CardsMonitoring/EffectiveReproductionNumber/Card.vue'
import HealthBurdenHospitalCard from '@/components/index/CardsMonitoring/HealthBurdenHospital/Card.vue'
import HospitalizedNumberCard from '@/components/index/CardsMonitoring/HospitalizedNumber/Card.vue'
import MonitoringConfirmedCasesNumberCard from '@/components/index/CardsMonitoring/MonitoringConfirmedCasesNumber/Card.vue'
import PositiveRateCard from '@/components/index/CardsMonitoring/PositiveRate/Card.vue'
import TestedNumberCard from '@/components/index/CardsMonitoring/TestedNumber/Card.vue'
import UntrackedRateCard from '@/components/index/CardsMonitoring/UntrackedRate/Card.vue'

export default Vue.extend({
  components: {
    CardsLazyRow,
  },
  data() {
    return {
      rows: [
        [ConfirmedCasesNumberCard, MonitoringConfirmedCasesNumberCard],
        [HospitalizedNumberCard, UntrackedRateCard],
        [PositiveRateCard, TestedNumberCard],
        [HealthBurdenCard, HealthBurdenHospitalCard],
      ],
    }
  },
})
</script>
