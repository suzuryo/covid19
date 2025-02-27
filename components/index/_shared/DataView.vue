<template>
  <v-card class="DataView">
    <div class="DataView-Inner">
      <div class="DataView-Header">
        <div v-if="!!$slots.dataSetPanel" class="DataView-DataSetPanel">
          <slot name="dataSetPanel" />
        </div>
      </div>

      <div v-if="$slots.attentionNote" class="DataView-AttentionNote">
        <slot name="attentionNote" />
      </div>

      <div class="DataView-Description">
        <slot name="description" />
      </div>

      <div>
        <slot name="button" />
      </div>

      <div class="DataView-Content">
        <slot />
      </div>

      <div class="DataView-Description DataView-Description--Additional">
        <expansion-panel
          v-if="$slots.dataTable"
          class="DataView-ExpansionPanel"
        >
          <slot name="dataTable" />
        </expansion-panel>
      </div>

      <div class="DataView-Description DataView-Description--Additional">
        <slot name="notes" />
      </div>

      <div class="DataView-Description DataView-Description--Additional">
        <slot name="additionalDescription" />
      </div>

      <div class="DataView-Space" />

      <div class="DataView-Footer">
        <div>
          <slot name="footer" />
          <div>
            <app-link class="Permalink" :to="permalink">
              <time :datetime="formattedDate">
                {{ $t('{date} 更新', { date: formattedDateForDisplay }) }}
              </time>
            </app-link>
          </div>
        </div>

        <share
          v-if="$route.query.embed != 'true'"
          :title="title"
          :title-id="titleId"
          class="Footer-Right"
        />
      </div>
    </div>
  </v-card>
</template>

<script lang="ts">
import Vue from 'vue'
import type { MetaInfo } from 'vue-meta'

import AppLink from '@/components/_shared/AppLink.vue'
import ExpansionPanel from '@/components/index/_shared/DataView/ExpansionPanel.vue'
import Share from '@/components/index/_shared/DataView/Share.vue'
import { convertDatetimeToISO8601Format } from '@/utils/formatDate'

export default Vue.extend({
  components: { AppLink, ExpansionPanel, Share },
  props: {
    title: {
      type: String,
      default: '',
    },
    titleId: {
      type: String,
      default: '',
    },
    date: {
      type: String,
      default: '',
    },
    headTitle: {
      type: String,
      default: '',
    },
  },
  head(): MetaInfo {
    // カードの個別ページの場合は、タイトルと更新時刻を`page/cards/_card`に渡す
    if (!this.$route.params.card) return {}

    return {
      title: this.headTitle ? this.headTitle : this.title,
      meta: [
        {
          hid: 'og:title',
          property: 'og:title',
          content: this.headTitle ? this.headTitle : this.title,
        },
        { hid: 'description', name: 'description', content: this.date },
        {
          hid: 'og:description',
          property: 'og:description',
          content: this.date,
        },
      ],
    }
  },
  computed: {
    formattedDate(): string {
      return convertDatetimeToISO8601Format(this.date)
    },
    formattedDateForDisplay(): string {
      return this.$d(new Date(this.date), 'dateTime')
    },
    permalink(): string {
      const permalink = `/cards/${this.titleId}`
      return this.localePath(permalink)
    },
  },
})
</script>

<style lang="scss">
.DataView {
  height: 100%;
  @include card-container();

  &-Header {
    display: flex;
    align-items: flex-start;
    flex-flow: column;
    padding: 0 10px;

    @include largerThan($medium) {
      padding: 0 5px;
    }

    @include largerThan($large) {
      justify-content: space-between;
      flex-flow: row;
      padding: 0;

      &.with-dataSetPanel {
        flex-flow: column;
      }
    }
  }

  &-Inner {
    display: flex;
    flex-flow: column;
    padding: 22px;
    height: 100%;
    @include lessThan($small) {
      padding: 15px 12px;
    }
  }

  &-Title {
    width: 100%;
    margin-bottom: 10px;
    line-height: 1.5;
    font-weight: normal;
    color: $gray-2;
    @include font-size(20);

    @include largerThan($large) {
      margin-bottom: 0;
    }

    span {
      display: inline-block;
    }
  }

  &-DataSetPanel {
    flex: 1 0 auto;
    width: 100%;
  }

  &-Content {
    margin: 10px 0;
    a:link {
      color: $link;
    }
    a:visited {
      color: $link-visited;
    }
    a:hover {
      text-decoration: underline;
    }
    a:active {
      text-decoration: none;
    }
  }

  &-Space {
    margin-top: 10px;
  }

  &-Description {
    margin-bottom: 10px;
    color: $gray-3;
    @include font-size(12);

    ul,
    ol {
      list-style: disc inside;
      padding-left: 1em;

      li {
        margin-left: 1.5em;
        text-indent: -1.5em;
      }
    }
  }

  &-Details {
    margin: 10px 0;

    .v-data-table {
      .text-end {
        text-align: right;
      }
      .text-nowrap {
        white-space: nowrap;
      }
    }
  }

  &-Footer {
    display: flex;
    justify-content: space-between;
    margin-top: auto;
    color: $gray-3;
    @include font-size(12);

    ul,
    ol {
      list-style-type: none;
      padding: 0;
    }

    .Permalink {
      color: $gray-3 !important;
    }

    .Footer-Right {
      display: flex;
      align-items: flex-end;
    }
  }

  &-AttentionNote {
    margin: 10px 0;
    padding: 12px;
    background-color: $emergency;
    border-radius: 4px;
    color: $gray-2;
    @include font-size(12);

    p {
      margin: 0;
    }
  }
}
</style>
