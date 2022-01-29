<template>
  <v-col id="HotelCapacityCard" cols="12" :md="md" class="DataCard">
    <client-only>
      <hotel-capacity-beds
        :title="$t('HotelCapacityCard.title')"
        title-id="hotel-capacity"
        :date="date"
        :bed-summary="bedSummary"
      >
        <template #notes>
          <ul>
            <li v-for="note in $t('HotelCapacityCard.notes')" :key="note">
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
      </hotel-capacity-beds>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import dayjs from 'dayjs'
import Vue from 'vue'

import AppLink from '@/components/_shared/AppLink.vue'
import HotelCapacityBeds from '@/components/index/CardsFeatured/HotelCapacity/Beds.vue'
import MainSummary from '@/data/main_summary.json'
import PositiveStatus from '@/data/positive_status.json'

export default Vue.extend({
  components: {
    HotelCapacityBeds,
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
    const hotel = MainSummary.宿泊療養
    const maxBeds = hotel > 300 ? hotel : 300
    const beds = [...Array(maxBeds).keys()]
    const bedSummary = {
      beds,
      maxBeds,
      hotel,
    }
    return {
      date,
      bedSummary,
    }
  },
})
</script>

<style lang="scss" module>
.bedExternalLink {
  margin-top: 10px;
  text-align: right;
}
</style>
