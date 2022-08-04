<template>
  <v-col
    id="TestTreatClinicMapCard"
    cols="12"
    :md="isSingleCard || md"
    class="DataCard"
  >
    <client-only>
      <test-treat-clinic-map
        :title="$t('TestTreatClinicMapCard.title')"
        :title-id="`clinic-map`"
        :date="`2021-08-12`"
      >
        <template #notes>
          <ul>
            <li v-for="note in $t('TestTreatClinicMapCard.notes')" :key="note">
              {{ note }}
            </li>
          </ul>
        </template>
      </test-treat-clinic-map>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'

import TestTreatClinicMap from '@/components/index/CardsReference/TestTreatClinic/Map.vue'
import { isSingleCard } from '@/utils/urls'

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
    TestTreatClinicMap,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  computed: {
    isSingleCard() {
      return isSingleCard(this.$route.path)
    },
  },
}

export default Vue.extend(options)
</script>
