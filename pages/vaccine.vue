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
    <static-card>
      <h3>盛岡市による全年齢向け集団接種</h3>
      <p>
        <app-link
          to="http://www.city.morioka.iwate.jp/kenkou/kenko/1031971/1032080/1035726.html"
        >
          盛岡市の集団接種
        </app-link>
      </p>
      <h4>Webの技術的な話</h4>
      <p>
        この集団接種(個人予約)の予約フォーム (ドメイン名 vc.liny.jp)
        の構築技術はSPAではなく、サーバー側でHTMLを生成するタイプなので、
        <code>ブラウザのリロードボタンを連打しまくるしかない。</code><br />
      </p>
      <h4>予約テクニック</h4>
      <p>
        集団接種会場が出現してみないと分からないが、県のフォームと違ってテクニックは特にない。<br />
        速い安定した固定回線を使い、複数端末や複数人でひたすらリロードして、
        空き枠が出現したらすぐに予約完了まで進めるしかない。
      </p>
    </static-card>
    <static-card>
      <h3>岩手県による全年齢向け集団接種</h3>
      <p>
        <app-link
          to="https://www.pref.iwate.jp/kurashikankyou/iryou/covid19/1037252.html"
        >
          岩手県の集団接種
        </app-link>
      </p>
      <h4>8月24日(火)正午の予約状況</h4>
      <p>
        8月24日(火)正午に行われたWebフォームからの個人予約の状況は以下の通り。<br />
        <br />
        8/28 滝沢会場 ： 14:00〜 95枠、14:30〜 105枠、15:00〜 104枠<br />
        8/28 花巻会場 ： 14:00〜 95枠、14:30〜 105枠、15:00〜 105枠<br />
        8/29 滝沢会場 ： 9:00〜 95枠、09:30〜 105枠、10:00〜 104枠、13:00〜
        95枠、13:30〜 114枠、14:00〜 104枠<br />
        8/29 花巻会場 ： 9:00〜 85枠、09:30〜 105枠、10:00〜 95枠、10:30〜
        95枠、13:00〜 85枠、13:30〜 142枠<br />
        <br />
        の予約枠が時間差で段階的に出現し、各枠は5秒くらいで埋まっていった。<br />
        <br />
        サイトにアクセスできない、繋がらない等は発生していない。サクサク動作していた。<br />
      </p>
      <h4>9月1日(水)正午の予約状況</h4>
      <p>
        9月1日(水)正午に行われたWebフォームからの個人予約の状況は以下の通り。<br />
        <br />
        9/4 滝沢会場 ： 15:00〜 200枠、15:30〜 250枠、16:00〜 233枠<br />
        9/4 花巻会場 ： 15:40〜 100枠、16:00〜 132枠<br />
        9/5 滝沢会場 ： 9:40〜 140枠、10:00〜 220枠、10:30〜 220枠、11:00〜
        193枠、13:40〜 140枠、14:00〜 220枠、14:30〜 220枠、15:00〜 194枠<br />
        9/5 花巻会場 ： 10:20〜 90枠、10:40〜 100枠、11:00〜 124枠、14:40〜
        100枠、15:00〜 134枠<br />
        <br />
        の予約枠が同時に出現し、<br />
        <br />
        9/4 滝沢会場は12時00分42秒には完売<br />
        9/4 花巻会場は12時00分53秒には完売<br />
        9/5 滝沢会場は12時01分04秒には完売<br />
        9/5 花巻会場は12時01分15秒には完売<br />
        <br />
        サイトにアクセスできない、繋がらない等は発生していない。サクサク動作していた。<br />
      </p>
      <h4>Webの技術的な話</h4>
      <p>
        この集団接種(個人予約)の予約フォーム (ドメイン名 vaccines.sciseed.jp)
        の構築技術はシングルページアプリケーション(SPA)なので、
        <code>ブラウザのリロードボタンを連打しても意味が無い。</code>
        ページをリロードしたからといって、新しい予約枠が出現するわけではない。<br />
        <br />
        「新規予約 -> 日付から探す -> モデルナ選択」の次の操作の
        <code
          >「日付を選択した瞬間」に予約枠のデータをサーバーから取得してくるように作られている</code
        >
        ので、最新の予約枠を更新取得するには、「日付を切り替える操作」をすればよい。
      </p>
      <h4>予約テクニック</h4>
      <ol>
        <li>
          9月8日の予約当日の正午までに、ログイン、新規予約、日付から探す、モデルナ選択、日付9月11日を選択まで終わらせておく
        </li>
        <li>
          12:00になったら、<code>日付選択で9月11日と9月12日を交互に選択</code>してサーバーから最新の予約枠データを取得する
        </li>
        <li>
          枠が出現して空きがあれば、次の画面に進んで予約を完了させる
          (ここで躊躇すると枠はすぐに埋まってしまう)
        </li>
        <li>予約に成功するか、希望の枠が出現するまで 2. を繰り返す</li>
        <li>
          全ての時間帯が出そろって、全て残り0枠になったらキャンセル枠を見つけるしかない
        </li>
        <li>
          「日付から探す」ルートは日付選択のテクニックが使えるが、「会場から探す」ルートは日付選択のテクニックが使えないし画面遷移が多く出遅れる
        </li>
      </ol>
      <p>ページをリロードしてしまったら 1. からやり直し</p>
      <p>責任は持てませんが、この方法が最速予約テクニックだと思う。</p>
      <h4>キャンセル枠</h4>
      <p>
        <del>
          予約済の人がキャンセルすると、予約できる枠が出現する。<br />
          キャンセル枠のチェックも基本は1〜6の予約テクニックの通り。<br />
          <br />
          常に張り付いて人力で確認するのは大変だから<a
            href="https://bit.ly/3mWcQBG"
            target="_blank"
            >コンピューターにやらせる</a
          >といいかもしれない。
        </del>
      </p>
      <p>
        9月8日の予約から、キャンセル枠が発生次第随時募集から、後日に一斉募集する方式に変更になった。
      </p>
    </static-card>
  </div>
</template>

<script lang="ts">
import { mdiNeedle } from '@mdi/js'
import Vue from 'vue'
import { MetaInfo } from 'vue-meta'

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
