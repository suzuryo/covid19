import { TranslateResult } from 'vue-i18n'

type Cities = {
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

type MapData = MapDataItem[]
