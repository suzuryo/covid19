<template>
  <v-col id="IwateNinshouRestaurantMapCard" cols="12" :md="12" class="DataCard">
    <client-only>
      <restaurant-map
        :title="$t('RestaurantCard.title')"
        :title-id="`restaurant-map`"
        :date="`2021-08-12`"
      >
        <template #notes>
          <ul>
            <li v-for="note in $t('RestaurantCard.notes')" :key="note">
              {{ note }}
            </li>
          </ul>
        </template>
      </restaurant-map>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'

import RestaurantMap from '@/components/index/CardsReference/IwateNinshou/Restaurant/Map.vue'

type DataType = {}
type MethodsType = {}
type ComputedType = {}
type PropsType = {}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  DataType,
  MethodsType,
  ComputedType,
  PropsType
> = {
  components: {
    RestaurantMap,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
}

export default Vue.extend(options)
</script>
