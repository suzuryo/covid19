<template>
  <cards-lazy-row :rows="rows" />
</template>

<script lang="ts">
import Vue from 'vue'

import CardsLazyRow from '@/components/index/_shared/CardsLazyRow.vue'
import ConfirmedCasesAttributesCard from '@/components/index/CardsReference/ConfirmedCasesAttributes/Card.vue'
import ConfirmedCasesByMunicipalitiesCard from '@/components/index/CardsReference/ConfirmedCasesByMunicipalities/Card.vue'
import RestaurantCard from '@/components/index/CardsReference/IwateNinshou/Restaurant/Card.vue'
import SelfDisclosuresCard from '@/components/index/CardsReference/SelfDisclosures/Card.vue'
import WhatsNewCard from '@/components/index/CardsReference/WhatsNew/Card.vue'

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
