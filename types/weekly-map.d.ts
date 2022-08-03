import type { TranslateResult } from 'vue-i18n'

export type Cities = {
  [key: string]: {
    d?: string
  }
}

export type MapDataItem = {
  label: TranslateResult
  last7days: number
  d?: string
}

export type MapData = MapDataItem[]
