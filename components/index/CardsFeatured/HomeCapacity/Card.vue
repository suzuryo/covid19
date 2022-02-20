<template>
  <v-col
    id="HomeCapacityCard"
    cols="12"
    :md="isSingleCard || md"
    class="DataCard"
  >
    <client-only>
      <home-capacity-beds
        :title="$t('HomeCapacityCard.title')"
        title-id="home-capacity"
        :date="date"
        :bed-summary="bedSummary"
      >
        <template #notes>
          <ul>
            <li v-for="note in $t('HomeCapacityCard.notes')" :key="note">
              {{ note }}
            </li>
          </ul>
          <div :class="$style.homeCapacityExternalLink">
            <div>
              <app-link :to="$t('ExtLink.岩手県48_3_1.url')">
                {{ $t('ExtLink.岩手県48_3_1.text') }}
              </app-link>
            </div>
          </div>
        </template>
      </home-capacity-beds>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import dayjs from 'dayjs'
import Vue from 'vue'

import AppLink from '@/components/_shared/AppLink.vue'
import HomeCapacityBeds from '@/components/index/CardsFeatured/HomeCapacity/Beds.vue'
import MainSummary from '@/data/main_summary.json'
import PositiveStatus from '@/data/positive_status.json'
import { isSingleCard } from '@/utils/urls'

export default Vue.extend({
  components: {
    HomeCapacityBeds,
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
    const home = MainSummary.自宅療養
    const beds = [...Array(home).keys()]
    const bedSummary = {
      beds,
      home,
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
.homeCapacityExternalLink {
  margin-top: 10px;
  text-align: right;
}
</style>
