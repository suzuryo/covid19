<template>
  <div>
    <div :class="$style.title">
      <page-header :title="headerItem.title">
        <template #SvgIcon>
          <span class="v-icon notranslate mr-2 theme--light">
            <covid-icon aria-hidden="true" />
          </span>
        </template>
        <template #PrinterButton>
          <printer-button
            :wrapper-class="$style.printerButton"
            to="/print/flow"
          />
        </template>
      </page-header>
    </div>
    <div :class="$style.container">
      <h3 ref="upperTrigger" :class="$style.conHeading">
        {{ $t('新型コロナウイルス感染症にかかる相談窓口について') }}
      </h3>
      <div id="sy" :class="$style.section">
        <h4 :class="$style.sxnHeading">
          <fig-cond-sy :class="$style.fig" aria-hidden="true" />
          {{ $t('症状のある方') }}
        </h4>
        <div :class="[$style.box, $style.bgYellow]">
          <h5 :class="$style.boxHeading">
            {{
              $t(
                '地域の医療機関（かかりつけ医）に電話で相談・受診予約をしてください'
              )
            }}
          </h5>
          <p>
            {{
              $t(
                'かかりつけ医にて受診・検査をおこないます（診療・検査医療機関の場合）'
              )
            }}
          </p>
          <p>
            {{ $t('または、かかりつけ医の紹介先で受診・検査となります') }}
          </p>
          <p :class="$style.detail">
            <app-link
              :to="extUrlShinryouKikanIchiran"
              :icon-size="20"
              :icon-class="$style.icon"
              :class="$style.detailButton"
              >{{ $t('診療・検査医療機関の一覧') }}
            </app-link>
          </p>
        </div>
        <div :class="[$style.box, $style.bgYellow]">
          <h5 :class="$style.boxHeading">
            {{
              $t(
                '相談する医療機関に迷う場合や「かかりつけ医」がない場合「いわて健康フォローアップセンター」'
              )
            }}
          </h5>
          <dl :class="$style.contact">
            <div>
              <dt>
                {{ $t('24時間 全日（土日・祝日を含む）') }}
              </dt>
              <dd>
                <a :class="$style.tel" href="tel:0570-089-005">
                  <icon-phone :class="$style.icon" aria-hidden="true" />
                  0570-089-005</a
                >
              </dd>
            </div>
          </dl>
          <p :class="$style.notice">
            {{
              $t(
                '聴覚に障害のある方をはじめ電話でのご相談が難しい方に向けてファクス (050-3730-7658) でも受付をしています。'
              )
            }}
          </p>
        </div>
        <div :class="[$style.box, $style.bgYellow]">
          <h5 :class="$style.boxHeading">
            {{ $t('自ら検査する場合') }}
          </h5>
          <p>
            {{
              $t(
                '重症化リスクの低い方は、検査キット送付センターを利用して自分で検査ができます'
              )
            }}
          </p>
          <p>
            {{
              $t(
                'いわて陽性者登録センターに登録すると、健康サポート・必要時の宿泊療養施設の入所・食糧支援・パルスオキシメーターの貸与などを受けることができます'
              )
            }}
          </p>
          <p :class="$style.detail">
            <app-link
              to="https://www.pref.iwate.jp/kurashikankyou/iryou/seido/1058849.html"
              :icon-size="20"
              :icon-class="$style.icon"
              :class="$style.detailButton"
              >{{ $t('いわて検査キット送付センター') }}
            </app-link>
          </p>
        </div>
      </div>
    </div>
    <div v-show="!['ja'].includes($i18n.locale)">
      <div :class="$style.detail">
        <app-link
          to="https://www.pref.iwate.jp/kyouikubunka/kokusai/1006971/1027622/1027623.html"
          :icon-size="20"
          :icon-class="$style.icon"
          :class="$style.detailButton"
        >
          See details (Iwate COVID-19 related information) [EN]
        </app-link>
      </div>
    </div>
    <div :class="$style.detail">
      <app-link
        to="https://www.pref.iwate.jp/kurashikankyou/iryou/covid19/index.html#callcenter"
        :icon-size="20"
        :icon-class="$style.icon"
        :class="$style.detailButton"
        >{{ $t('詳細を見る（岩手県新型コロナウイルス感染症関連情報）') }}
      </app-link>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'

import AppLink from '@/components/_shared/AppLink.vue'
import PageHeader from '@/components/_shared/PageHeader.vue'
import PrinterButton from '@/components/_shared/PrinterButton.vue'
import Urls from '@/data/urls.json'
import CovidIcon from '@/static/covid.svg'
import FigCondAnx from '@/static/flow/cond_anx.svg'
import FigCondSy from '@/static/flow/cond_sy.svg'
import IconPhone from '@/static/flow/phone.svg'

type Data = {
  headerItem: {
    title: string
  }
  extUrlShinryouKikanIchiran: string
}
type Methods = {}
type Computed = {}
type Props = {}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  Data,
  Methods,
  Computed,
  Props
> = {
  name: 'Flow',
  components: {
    CovidIcon,
    PrinterButton,
    PageHeader,
    AppLink,
    FigCondSy,
    FigCondAnx,
    IconPhone,
  },
  data() {
    const extUrlShinryouKikanIchiran =
      Urls.items.find((a) => a.item === '診療医療機関の一覧')?.url ?? ''
    const extUrlFreePCR =
      Urls.items.find(
        (a) => a.item === '無症状の方の薬局等におけるPCR検査等の無料化'
      )?.url ?? ''

    return {
      headerItem: {
        title: this.$t('SideNavigation.a[4]') as string,
      },
      extUrlShinryouKikanIchiran,
      extUrlFreePCR,
    }
  },
  head(): any {
    return {
      title: this.$t('SideNavigation.a[4]') as string,
    }
  },
}

export default options
</script>

<style lang="scss" module>
/* stylelint-disable no-descending-specificity */

$fzSmall: 14;
$fzRegular: 16;
$fzMedium: 18;
$fzLarge: 20;
$fzHuge: 22;
$fzHeading: 24;
$fzHeadingL: 26;

$padding: 20;
$margin: 20;

.title {
  .printerButton {
    margin: 0 0 0 auto;
    a {
      color: $green-1;
      @include font-size(14);
    }
  }
}
.container {
  background-color: $white;
  box-shadow: $shadow;
  border: 0.5px solid $gray-4 !important;
  border-radius: 4px;
  padding: $padding * 1px;
  line-height: 1.35;
  color: $gray-2;
  @include font-size($fzRegular);

  > .conHeading {
    @include font-size($fzHeading);
  }
  ul {
    padding-left: 0; // override Vuetify style
  }
  p {
    margin-bottom: 0; // override Vuetify style
  }
}
.section {
  margin-top: $margin * 1.5px;
  padding: $padding * 1px;
  border: 3px solid $gray-3;
  border-radius: 10px;
  background-color: $white;
  &.yellow {
    border-width: 4px;
    border-color: $emergency;
  }
  > * {
    line-height: 1.5;
    &:not(.box, .boxes, :first-child) {
      margin-top: $margin * 1px;
    }
  }
  > .sxnHeading {
    text-align: center;
    font-weight: bold;
    > svg.fig {
      margin-top: 1px;
      max-width: 80px;
      max-height: 80px;
      vertical-align: middle;
    }
    @include font-size($fzHeadingL);
  }
  > .sxnText {
    margin-top: 20px;
    text-align: center;
    font-weight: bold;
    @include font-size($fzMedium);
  }
  > .hr {
    margin-top: $margin * 1px;
    padding-top: $margin * 1.5px;
    border-top: 1px solid $gray-2;
  }
}
.box {
  margin-top: $margin * 1px;
  display: flex;
  flex-direction: column;
  align-items: stretch;
  justify-content: center;
  border-radius: 4px;
  padding: $padding * 1px;
  text-align: center;
  line-height: 1.65;
  &.bgGray {
    background-color: $gray-2;
    color: $white;
    .icon path {
      fill: $white; // 内包するアイコンの色を変更
    }
  }
  &.bgYellow {
    background-color: $emergency;
  }
  > .boxHeading {
    font-weight: bold;
    @include font-size($fzLarge);
  }
  > .grow {
    flex: 1 0 auto;
  }
  > * {
    max-width: 100%;
  }
  > *:not(:first-child) {
    margin-top: $margin * 0.75px;
  }
  > .notice {
    width: 100%;
    padding: $margin * 1px;
    border-radius: 4px;
    background-color: $white;
    color: #a00000;
    text-align: center;
    font-weight: bold;
    line-height: 1.35;
    @include font-size($fzSmall);
  }
  > .contact {
    > div {
      display: flex;
      width: 100%;
      justify-content: center;
      align-items: flex-end;
      flex-wrap: wrap;
      > dt {
        margin-right: 0.5em;
      }
      > dd {
        text-align: left;
      }
    }
    > *:not(:first-child) {
      margin-top: $margin * 1px;
    }
  }
  li {
    list-style-type: none;
  }
  a {
    color: inherit;
    text-decoration: none;
    &:not(.tel) {
      > i {
        vertical-align: baseline;
      }
      &:hover {
        text-decoration: underline;
      }
    }
  }
}
.container .box a {
  color: inherit; // for IE11
}
.tel {
  font-weight: bold;
  vertical-align: baseline;
  white-space: nowrap;
  line-height: 1px * $fzHuge * 1.35;
  padding: 0 0.25em;
  @include font-size($fzHuge);

  > svg {
    vertical-align: baseline;
    max-width: 0.7em;
    max-height: 0.7em; // for IE11
    width: 100%;
  }

  &:visited,
  &:hover,
  &:active,
  &:focus {
    outline: 1px dotted $white;
  }
}
.detail {
  text-align: center;
  .detailButton {
    @include button-text('md');
    @include font-size(20);

    margin: ($margin * 1.5px) auto 0;
    font-weight: bold;
    text-decoration: none;
    color: $green-1 !important;
    &:hover {
      color: $white !important;
    }
    > .icon {
      margin-left: 2px;
      color: $green-1 !important;
    }
  }
}

// 600
@function px2vw($px, $vw: 600) {
  @return $px / $vw * 100vw;
}
@include lessThan($small) {
  .title {
    margin-bottom: px2vw($margin);
  }
  .container {
    padding: px2vw($padding);
    font-size: px2vw($fzRegular);
    > .conHeading {
      font-size: px2vw($fzHeading);
    }
  }
  .section {
    //margin-top: px2vw($margin * 1.5);
    margin-top: 20px; // フローティングの都合で固定
    padding: px2vw($padding);
    border-width: px2vw(3);
    border-radius: px2vw(10);
    &.yellow {
      border-width: px2vw(3);
    }
    > * {
      &:not(.box, .boxes, :first-child) {
        margin-top: px2vw($margin);
      }
    }
    > .sxnHeading {
      font-size: px2vw($fzHeadingL);
      > svg.fig {
        margin-top: 1px;
        max-width: 80px;
        max-height: 80px;
      }
    }
    > .sxnText {
      font-size: px2vw($fzMedium);
    }
    > .hr {
      margin-top: px2vw($margin);
      padding-top: px2vw($margin * 1.5);
    }
  }
  .box {
    margin-top: px2vw($margin);
    padding: px2vw($padding);
    border-radius: px2vw(4);
    &.border {
      border-width: px2vw(2);
    }
    > .boxHeading {
      font-size: px2vw($fzLarge);
    }
    > *:not(:first-child) {
      margin-top: px2vw($margin * 0.75);
    }
    > .notice {
      padding: px2vw($margin);
      border-radius: px2vw(4);
      font-size: px2vw($fzSmall);
    }
    > .contact {
      > *:not(:first-child) {
        margin-top: px2vw($margin);
      }
    }
  }
  .tel {
    font-size: px2vw($fzHuge);
  }
  .detail {
    .button {
      padding: px2vw(24) px2vw(36);
      margin: px2vw($margin * 1.5) auto 0;
      font-size: px2vw(20);
    }
  }
}
</style>
