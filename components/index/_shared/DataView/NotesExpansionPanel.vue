<template>
  <div v-if="$slots.notes" class="NotesExpansionPanel">
    <v-expansion-panels v-if="showDetails" flat>
      <v-expansion-panel>
        <v-expansion-panel-header
          :hide-actions="true"
          :style="{ transition: 'none' }"
          @click="toggleDetails"
        >
          <div class="v-expansion-panel-header__icon grey--text text--darken-2">
            <v-icon left size="24">{{ mdiChevronRight }}</v-icon>
          </div>
          <span class="expansion-panel-text grey--text text--darken-2">
            {{ expansionPanelText }}
          </span>
        </v-expansion-panel-header>
        <v-expansion-panel-content class="grey--text text--darken-2">
          <slot name="notes" />
        </v-expansion-panel-content>
      </v-expansion-panel>
    </v-expansion-panels>
    <template v-else>
      <slot name="notes" />
    </template>
  </div>
</template>

<script lang="ts">
import { mdiChevronRight } from '@mdi/js'
import Vue from 'vue'

import { EventBus, TOGGLE_EVENT } from '@/utils/card-event-bus'

export default Vue.extend({
  props: {
    expansionPanelText: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      showDetails: false,
      mdiChevronRight,
    }
  },
  mounted() {
    this.showDetails = true
  },
  methods: {
    toggleDetails() {
      EventBus.$emit(TOGGLE_EVENT, { dataView: this.$parent })
    },
  },
})
</script>

<style lang="scss" scoped>
.v-expansion-panels {
  color: $gray-2 !important;
}

.v-expansion-panel-header {
  padding: 5px 0;
}

.v-expansion-panel-header__icon {
  margin-left: -5px !important;

  & .v-icon--left {
    margin-right: 5px;
  }

  .v-expansion-panel--active & .v-icon {
    transform: rotate(90deg) !important;
  }
}

.expansion-panel-text {
  @include font-size(12);
}
</style>
