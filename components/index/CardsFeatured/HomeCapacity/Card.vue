<template>
  <v-col id="HomeCapacityCard" cols="12" :md="md" class="DataCard">
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
        </template>
      </home-capacity-beds>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import dayjs from 'dayjs'
import Vue from 'vue'

import HomeCapacityBeds from '@/components/index/CardsFeatured/HomeCapacity/Beds.vue'
import MainSummary from '@/data/main_summary.json'
import PositiveStatus from '@/data/positive_status.json'

export default Vue.extend({
  components: {
    HomeCapacityBeds,
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
})
</script>
