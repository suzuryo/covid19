<template>
  <data-view :title="title" :title-id="titleId" :date="date">
    <div class="SelfDisclosures-Content">
      <v-data-table
        :ref="'displayedTable'"
        :items="items"
        :mobile-breakpoint="0"
        hide-default-header
        :headers="headers"
        class="cardTable"
        :search="search"
        :footer-props="{
          'items-per-page-options': isSingleCard
            ? [20, 30, 50, 100, 200, 300, -1]
            : [10, 30, 50, 100, 200, 300, -1],
          'items-per-page-text': $t('DataView_Footer[0]'),
        }"
      >
        <template #top>
          <v-text-field
            v-model="search"
            :append-icon="mdiMagnify"
            dense
            single-line
            :onchange="searchOnChange(search)"
          />
        </template>
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
        :self-disclosure-form="true"
      />
    </template>
  </data-view>
</template>

<script lang="ts">
import { mdiMagnify } from '@mdi/js'
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'

import AppLink from '@/components/_shared/AppLink.vue'
import DataView from '@/components/index/_shared/DataView.vue'
import NotesExpansionPanel from '@/components/index/_shared/DataView/NotesExpansionPanel.vue'
import DataViewDataSetPanel from '@/components/index/_shared/DataViewDataSetPanel.vue'
import { getDayjsObject } from '@/utils/formatDate'
import { isSingleCard } from '@/utils/urls'

type Data = {
  search: string
  headers: {
    text: string
    align: string
    filterable: boolean
    value: string
  }[]
  mdiMagnify: string
}
type Methods = {
  formatDate: (dateString: string) => string
  formatDateTime: (dateString: string) => string
  searchOnChange: (searchTerm: string) => void
}
type Computed = {
  isSingleCard: boolean
}
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
  data() {
    const search = ''
    const headers = [
      {
        text: 'text',
        align: 'start',
        filterable: true,
        value: 'text',
      },
      {
        text: 'date',
        align: 'end',
        filterable: true,
        value: 'date',
      },
    ]
    return {
      search,
      headers,
      mdiMagnify,
    }
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
    searchOnChange(searchTerm: string) {
      this.$gtm.push({
        event: 'selfDisclosuresSearch',
        selfDisclosuresSearchTerm: searchTerm,
      })
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

<style lang="scss" scoped>
.SelfDisclosures {
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
