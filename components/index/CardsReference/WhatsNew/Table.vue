<template>
  <data-view :title="title" :title-id="titleId" :date="date">
    <div class="WhatsNew-Content">
      <v-data-table
        :ref="'displayedTable'"
        :items="items"
        :mobile-breakpoint="0"
        hide-default-header
        class="cardTable"
        :footer-props="{
          'items-per-page-options': [10, 30, 50, 100, 200, 300, -1],
          'items-per-page-text': $t('DataView_Footer[0]'),
        }"
      >
        <template #body="{ items }">
          <tbody>
            <tr v-for="(item, i) in items" :key="i">
              <td class="text-start">
                <template v-if="item.url">
                  <app-link :to="item.url" :show-icon="false">
                    {{ item.text }}
                  </app-link>
                </template>
                <template v-else>
                  {{ item.text }}
                </template>
              </td>
              <td class="text-end text-no-wrap">
                <time :datetime="formatDateTime(item.date)">{{
                  formatDate(item.date)
                }}</time>
              </td>
            </tr>
          </tbody>
        </template>
        <template slot="footer.page-text" slot-scope="props">
          {{
            $t('DataView_Footer[1]', {
              itemsLength: props.itemsLength,
              pageStart: props.pageStart,
              pageStop: props.pageStop,
            })
          }}
        </template>
      </v-data-table>
    </div>
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

import AppLink from '@/components/_shared/AppLink.vue'
import DataView from '@/components/index/_shared/DataView.vue'
import NotesExpansionPanel from '@/components/index/_shared/DataView/NotesExpansionPanel.vue'
import DataViewDataSetPanel from '@/components/index/_shared/DataViewDataSetPanel.vue'
import { getDayjsObject } from '@/utils/formatDate'

type Data = {}
type Methods = {
  formatDate: (dateString: string) => string
  formatDateTime: (dateString: string) => string
}
type Computed = {}
type Props = {
  title: string
  titleId: string
  date: string
  items: object
}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  Data,
  Methods,
  Computed,
  Props
> = {
  components: {
    AppLink,
    DataView,
    DataViewDataSetPanel,
    NotesExpansionPanel,
  },
  props: {
    title: {
      type: String,
      default: '',
    },
    titleId: {
      type: String,
      required: false,
      default: '',
    },
    date: {
      type: String,
      required: true,
      default: '',
    },
    items: {
      type: Array,
      required: true,
      default: () => {},
    },
  },
  mounted() {
    const vTables = this.$refs.displayedTable as Vue
    const vTableElement = vTables.$el
    const tables = vTableElement.querySelectorAll('table')
    // NodeListをIE11でforEachするためのワークアラウンド
    const nodes = Array.prototype.slice.call(tables, 0)
    nodes.forEach((table: HTMLElement) => {
      table.setAttribute('tabindex', '0')
    })
  },
  methods: {
    formatDate(dateString: string): string {
      const date = getDayjsObject(dateString)
      if (date.isValid()) {
        return this.$d(date.toDate(), 'dateWithoutYear')
      } else {
        return dateString
      }
    },
    formatDateTime(dateString: string): string {
      const date = getDayjsObject(dateString)
      return date.format('YYYY-MM-DD')
    },
  },
}

export default Vue.extend(options)
</script>

<style lang="scss" scoped>
.WhatsNew {
  &-Content {
    .cardTable {
      table {
        tbody {
          tr {
            td {
              padding: 10px !important;
              @include font-size(12);
            }
          }
        }
      }
    }
  }
}
</style>
