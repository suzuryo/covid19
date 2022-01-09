<template>
  <cards-lazy-row :rows="rows" />
</template>

<script lang="ts">
import Vue from 'vue'

import CardsLazyRow from '@/components/index/_shared/CardsLazyRow.vue'

const AgeGroupCard = () =>
  import('@/components/index/CardsMonitoring/AgeGroup/Card.vue')
const ConfirmedCasesNumberCard = () =>
  import('@/components/index/CardsMonitoring/ConfirmedCasesNumber/Card.vue')
const EffectiveReproductionNumberCard = () =>
  import(
    '@/components/index/CardsMonitoring/EffectiveReproductionNumber/Card.vue'
  )
const HospitalizedNumberCard = () =>
  import('@/components/index/CardsMonitoring/HospitalizedNumber/Card.vue')
const MonitoringConfirmedCasesNumberCard = () =>
  import(
    '@/components/index/CardsMonitoring/MonitoringConfirmedCasesNumber/Card.vue'
  )
const PositiveRateCard = () =>
  import('@/components/index/CardsMonitoring/PositiveRate/Card.vue')
const TestedNumberCard = () =>
  import('@/components/index/CardsMonitoring/TestedNumber/Card.vue')
const UntrackedRateCard = () =>
  import('@/components/index/CardsMonitoring/UntrackedRate/Card.vue')

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
        [AgeGroupCard, EffectiveReproductionNumberCard],
      ],
    }
  },
})
</script>
