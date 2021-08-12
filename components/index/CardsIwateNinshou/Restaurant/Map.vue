<template>
  <data-view :title="title" :title-id="titleId" :date="date">
    <iframe
      :class="$style.map"
      src="https://www.google.com/maps/d/embed?mid=1mtMlirFd9VZrNn5D-EtmshbUTbzQUyN3"
    />
    <template #notes>
      <notes-expansion-panel
        class="DataView-ExpansionPanel"
        :expansion-panel-text="$t('Common.注')"
      >
        <template #notes>
          <slot name="notes" />
        </template>
      </notes-expansion-panel>
    </template>
    <template #dataSetPanel>
      <data-view-data-set-panel
        :title="title"
        :card-path="`/cards/${titleId}`"
      />
    </template>
  </data-view>
</template>

<script lang="ts">
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'

import DataView from '@/components/index/_shared/DataView.vue'
import NotesExpansionPanel from '@/components/index/_shared/DataView/NotesExpansionPanel.vue'
import DataViewDataSetPanel from '@/components/index/_shared/DataViewDataSetPanel.vue'

type DataType = {}
type MethodsType = {}
type ComputedType = {}
type PropsType = {
  title: string
  titleId: string
  date: string
}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  DataType,
  MethodsType,
  ComputedType,
  PropsType
> = {
  components: { DataView, DataViewDataSetPanel, NotesExpansionPanel },
  props: {
    title: {
      required: true,
      type: String,
      default: '',
    },
    titleId: {
      required: true,
      type: String,
      default: '',
    },
    date: {
      required: true,
      type: String,
      default: '',
    },
  },
}

export default Vue.extend(options)
</script>

<style lang="scss" module>
.map {
  border: 0;
  width: 100%;
  min-height: 700px;
  max-height: 900px;
  @include lessThan($small) {
    min-height: 600px;
    max-height: 800px;
  }
}
</style>
