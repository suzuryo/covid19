<template>
  <cards-lazy-row :rows="rows" />
</template>

<script lang="ts">
import Vue from 'vue'

import CardsLazyRow from '@/components/index/_shared/CardsLazyRow.vue'

const ConfirmedCasesAttributesCard = () =>
  import('@/components/index/CardsReference/ConfirmedCasesAttributes/Card.vue')
const ConfirmedCasesByMunicipalitiesCard = () =>
  import(
    '@/components/index/CardsReference/ConfirmedCasesByMunicipalities/Card.vue'
  )
const RestaurantCard = () =>
  import('@/components/index/CardsReference/IwateNinshou/Restaurant/Card.vue')
const SelfDisclosuresCard = () =>
  import('@/components/index/CardsReference/SelfDisclosures/Card.vue')
const WhatsNewCard = () =>
  import('@/components/index/CardsReference/WhatsNew/Card.vue')

export default Vue.extend({
  components: {
    CardsLazyRow,
  },
  data() {
    return {
      rows: [
        [WhatsNewCard, SelfDisclosuresCard],
        [ConfirmedCasesAttributesCard, ConfirmedCasesByMunicipalitiesCard],
        [RestaurantCard],
      ],
    }
  },
})
</script>
