<template>
  <div class="Vaccine">
    <page-header :title="headerItem.title" :icon-path="headerItem.iconPath" />
    <static-card>
      <h3>
        <app-link
          to="https://www.pref.iwate.jp/kurashikankyou/iryou/covid19/1037252.html"
          :icon-size="24"
          >{{ $t('新型コロナウイルスワクチン接種に関する情報') }}
        </app-link>
      </h3>
      <p>
        {{
          $t(
            '岩手県では、新型コロナウイルスワクチンの安全かつ円滑な接種に向けて、市町村や医療機関などと連携し対応しています。'
          )
        }}
      </p>
    </static-card>
    <static-card>
      <h3>
        <app-link to="https://www.cov19-vaccine.mhlw.go.jp/qa/" :icon-size="24"
          >{{ $t('新型コロナワクチンQ&A') }}
        </app-link>
      </h3>
      <p>
        {{
          $t('新型コロナウイルスワクチンに関する、厚生労働省のWebサイトです。')
        }}
      </p>
    </static-card>
    <static-card>
      <h3>
        <app-link to="https://v-sys.mhlw.go.jp/" :icon-size="24"
          >{{ $t('コロナワクチンナビ') }}
        </app-link>
      </h3>
      <p>
        {{
          $t(
            '新型コロナウイルスワクチン接種に関する、厚生労働省のWebサイトです。'
          )
        }}
      </p>
    </static-card>
  </div>
</template>

<script lang="ts">
import { mdiNeedle } from '@mdi/js'
import Vue from 'vue'
import type { MetaInfo } from 'vue-meta'

import AppLink from '@/components/_shared/AppLink.vue'
import PageHeader from '@/components/_shared/PageHeader.vue'
import StaticCard from '@/components/_shared/StaticCard.vue'

export default Vue.extend({
  name: 'Vaccine',
  components: {
    PageHeader,
    StaticCard,
    AppLink,
  },
  data() {
    return {
      headerItem: {
        iconPath: mdiNeedle,
        title: this.$t('SideNavigation.a[10]') as string,
      },
    }
  },
  head(): MetaInfo {
    return {
      title: this.$t('SideNavigation.a[10]') as string,
    }
  },
})
</script>
