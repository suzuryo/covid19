<template>
  <cards-lazy-row :rows="rows" />
</template>

<script lang="ts">
import Vue from 'vue'

import CardsLazyRow from '@/components/index/_shared/CardsLazyRow.vue'
import AgeGroupCard from '@/components/index/CardsMonitoring/AgeGroup/Card.vue'
import ConfirmedCasesNumberCard from '@/components/index/CardsMonitoring/ConfirmedCasesNumber/Card.vue' // 報告日別による陽性者数の推移
import EffectiveReproductionNumberCard from '@/components/index/CardsMonitoring/EffectiveReproductionNumber/Card.vue' // 実効再生産数
import HospitalizedNumberCard from '@/components/index/CardsMonitoring/HospitalizedNumber/Card.vue' // 入院と宿泊療養の推移
import MonitoringConfirmedCasesNumberCard from '@/components/index/CardsMonitoring/MonitoringConfirmedCasesNumber/Card.vue' // 新規陽性者数の7日間移動平均
import PositiveRateCard from '@/components/index/CardsMonitoring/PositiveRate/Card.vue' // 検査の陽性率・PCR検査の7日間移動平均
import TestedNumberCard from '@/components/index/CardsMonitoring/TestedNumber/Card.vue' // 検査実施件数
import UntrackedRateCard from '@/components/index/CardsMonitoring/UntrackedRate/Card.vue' // 接触歴等不明者数(7日間移動平均)

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
