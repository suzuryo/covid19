<template>
  <v-btn-toggle
    :aria-controls="targetId"
    :value="value"
    class="DataSelector"
    mandatory
    @change="$emit('input', $event)"
  >
    <v-btn
      v-ripple="false"
      :aria-pressed="value === 'transition' ? 'true' : 'false'"
      value="transition"
      class="DataSelector-Button"
    >
      {{ $t('日別') }}
    </v-btn>
    <v-btn
      v-ripple="false"
      :aria-pressed="value === 'cumulative' ? 'true' : 'false'"
      value="cumulative"
      class="DataSelector-Button"
    >
      {{ $t('Common.累計') }}
    </v-btn>
  </v-btn-toggle>
</template>

<script lang="ts">
import Vue from 'vue'

export default Vue.extend({
  name: 'DataSelector',
  props: {
    value: {
      type: String,
      default: 'transition',
    },
    targetId: {
      type: String,
      default: (val: string | null) => {
        return val && val !== '' ? val : null
      },
    },
  },
})
</script>

<style lang="scss" scoped>
.DataSelector {
  margin-top: 20px;
  border: 1px solid $gray-4;
  background-color: $white;

  &-Button {
    border: none !important;
    margin: 2px;
    border-radius: 4px !important;
    height: 24px !important;
    color: $gray-1 !important;
    background-color: $white !important;
    @include font-size(12, true);

    &::before {
      background-color: inherit;
    }

    &:focus {
      outline: dotted $gray-3 1px;
    }
  }

  & .v-btn--active {
    background-color: $gray-2 !important;
    color: $white !important;
  }
}
</style>
