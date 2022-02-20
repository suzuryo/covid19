<template>
  <v-col
    id="HealthBurdenCard"
    cols="12"
    :md="isSingleCard || md"
    class="DataCard"
  >
    <client-only>
      <health-burden-table
        :info-titles="[$t('HealthBurdenCard.title')]"
        title-id="health-burden"
        :date="date"
        :health-burden="HealthBurden"
      >
        <template #notes>
          <ul>
            <li v-for="note in $t('HealthBurdenCard.notes')" :key="note">
              {{ note }}
            </li>
          </ul>
        </template>
      </health-burden-table>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import dayjs from 'dayjs'
import Vue from 'vue'

import HealthBurdenTable from '@/components/index/CardsFeatured/HealthBurden/Table.vue'
import HealthBurden from '@/data/health_burden.json'
import { isSingleCard } from '@/utils/urls'

export default Vue.extend({
  components: {
    HealthBurdenTable,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    const date = dayjs(HealthBurden.date).format('YYYY/MM/DD HH:mm')
    return {
      date,
      HealthBurden,
    }
  },
  computed: {
    isSingleCard() {
      return isSingleCard(this.$route.path)
    },
  },
})
</script>
