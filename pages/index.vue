<template>
  <div>
    <page-header
      :icon-path="headerItem.iconPath"
      :title="headerItem.title"
      :updated-at="lastUpdateAsString"
    />
    <site-top-upper />
    <cards-tab />
  </div>
</template>

<script lang="ts">
import { mdiChartTimelineVariant } from '@mdi/js'
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'
import type { MetaInfo } from 'vue-meta'

import PageHeader from '@/components/_shared/PageHeader.vue'
import CardsTab from '@/components/index/CardsTab.vue'
import SiteTopUpper from '@/components/index/SiteTopUpper.vue'
import { date } from '@/data/main_summary.json'

type Data = {
  headerItem: {
    iconPath: string
    title: string
  }
  date: string
}
type Methods = {}
type Computed = {
  lastUpdateAsString: string
}
type Props = {}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  Data,
  Methods,
  Computed,
  Props
> = {
  components: {
    CardsTab,
    PageHeader,
    SiteTopUpper,
  },
  data() {
    return {
      date,
      headerItem: {
        iconPath: mdiChartTimelineVariant,
        title: this.$t('Common.岩手の最新感染動向') as string,
      },
    }
  },
  computed: {
    lastUpdateAsString() {
      return this.date
    },
  },
  head(): MetaInfo {
    return {
      title: this.$t('Common.岩手の最新感染動向') as string,
    }
  },
}

export default options
</script>
