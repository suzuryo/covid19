<template>
  <v-col
    id="HospitalCapacityCard"
    cols="12"
    :md="isSingleCard || md"
    class="DataCard"
  >
    <client-only>
      <hospital-capacity-beds
        :title="$t('HospitalCapacityCard.title')"
        title-id="hospital-capacity"
        :date="date"
        :bed-summary="bedSummary"
      >
        <template #notes>
          <ul>
            <li v-for="note in $t('HospitalCapacityCard.notes')" :key="note">
              {{ note }}
            </li>
          </ul>
          <div :class="$style.bedExternalLink">
            <div>
              <app-link :to="$t('ExtLink.岩手県17_2.url')">
                {{ $t('ExtLink.岩手県17_2.text') }}
              </app-link>
            </div>
            <div>
              <app-link :to="$t('ExtLink.岩手県19_41.url')">
                {{ $t('ExtLink.岩手県19_41.text') }}
              </app-link>
            </div>
            <div>
              <app-link :to="$t('ExtLink.岩手県38_3.url')">
                {{ $t('ExtLink.岩手県38_3.text') }}
              </app-link>
            </div>
            <div>
              <app-link :to="$t('ExtLink.岩手県_3_11.url')">
                {{ $t('ExtLink.岩手県_3_11.text') }}
              </app-link>
            </div>
          </div>
        </template>
      </hospital-capacity-beds>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import dayjs from 'dayjs'
import Vue from 'vue'

import AppLink from '@/components/_shared/AppLink.vue'
import HospitalCapacityBeds from '@/components/index/CardsFeatured/HospitalCapacity/Beds.vue'
import MainSummary from '@/data/main_summary.json'
import PositiveStatus from '@/data/positive_status.json'
import { isSingleCard } from '@/utils/urls'

export default Vue.extend({
  components: {
    HospitalCapacityBeds,
    AppLink,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    const date = dayjs(PositiveStatus.date).format('YYYY/MM/DD HH:mm')
    const hospital = MainSummary.入院
    const waiting = MainSummary.調整中
    const maxBeds = hospital + waiting > 400 ? hospital + waiting : 400
    const beds = [...Array(maxBeds).keys()]
    const bedSummary = {
      beds,
      maxBeds,
      hospital,
      waiting,
    }
    return {
      date,
      bedSummary,
    }
  },
  computed: {
    isSingleCard() {
      return isSingleCard(this.$route.path)
    },
  },
})
</script>

<style lang="scss" module>
.bedExternalLink {
  margin-top: 10px;
  text-align: right;
}
</style>
