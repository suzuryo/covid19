import type { TranslateResult } from 'vue-i18n'

export type Cities = {
  [key: string]: {
    count: number
    area: string
    d?: string
  }
}

type MapDataItem = {
  area: TranslateResult
  label: TranslateResult
  last7days: number
  ruby: TranslateResult
  d?: string
}

export type MapData = MapDataItem[]
