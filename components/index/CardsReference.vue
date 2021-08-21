<template>
  <cards-lazy-row :rows="rows" />
</template>

<script lang="ts">
import Vue from 'vue'

import CardsLazyRow from '@/components/index/_shared/CardsLazyRow.vue'
import RestaurantCard from '@/components/index/CardsIwateNinshou/Restaurant/Card.vue'
import ConfirmedCasesAttributesCard from '@/components/index/CardsReference/ConfirmedCasesAttributes/Card.vue'
import ConfirmedCasesByMunicipalitiesCard from '@/components/index/CardsReference/ConfirmedCasesByMunicipalities/Card.vue'
import SelfDisclosuresCard from '@/components/index/CardsReference/SelfDisclosures/Card.vue' // 自主公表
import WhatsNewCard from '@/components/index/CardsReference/WhatsNew/Card.vue' // 最新のお知らせ

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
