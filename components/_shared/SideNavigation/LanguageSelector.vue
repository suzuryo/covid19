<template>
  <div class="LanguageSelector">
    <div class="LanguageSelector-Background">
      <earth-icon class="EarthIcon" aria-hidden="true" />
      <select-menu-icon class="SelectMenuIcon" aria-hidden="true" />
    </div>
    <label>
      <select
        id="LanguageSelector"
        v-model="currentLocaleCode"
        class="LanguageSelector-Menu"
        @change="handleChangeLanguage"
      >
        <option
          v-for="locale in $i18n.locales"
          :key="locale.code"
          :value="locale.code"
          :title="`Switch to ${locale.description}`"
        >
          {{ locale.name }}
        </option>
      </select>
    </label>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'

import EarthIcon from '@/static/earth.svg'
import SelectMenuIcon from '@/static/selectmenu.svg'

type LocalData = {
  currentLocaleCode: string
}

export default Vue.extend({
  components: {
    EarthIcon,
    SelectMenuIcon,
  },
  data(): LocalData {
    return {
      currentLocaleCode: this.$root.$i18n.locale,
    }
  },
  watch: {
    '$root.$i18n.locale'(locale: string) {
      this.currentLocaleCode = locale
    },
  },
  methods: {
    handleChangeLanguage() {
      this.$root.$i18n.setLocale(this.currentLocaleCode)
    },
  },
})
</script>

<style lang="scss" scoped>
.LanguageSelector {
  position: relative;
}

.LanguageSelector-Background {
  display: flex;
  align-items: center;
  padding: 0 6px;
  border-radius: 4px;
  height: 28px;

  .EarthIcon {
    order: -1;
  }

  .SelectMenuIcon {
    margin-left: auto;
  }

  &::before {
    content: 'Lang:';
    margin-left: 4px;
    color: $gray-1;
    @include font-size(12);
    @include lessThan($small) {
      @include font-size(16);
    }
  }
}

.LanguageSelector-Menu {
  // select 要素のリセット
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  background: transparent;
  // IEで矢印ボタンを消す
  &::-ms-expand {
    display: none;
  }

  border: 1px solid $gray-4;

  // 背景に被せて位置など調整
  z-index: 1;
  position: absolute;
  top: 0;
  left: 0;
  padding-left: 60px;
  width: 100%;
  height: 28px;
  line-height: 28px;
  @include font-size(12);

  &:focus {
    border: 1px dotted $gray-3;
    outline: none;
  }
  @include lessThan($small) {
    padding-left: 70px;
    @include font-size(16);
  }
}
</style>
