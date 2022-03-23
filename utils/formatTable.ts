import dayjs from 'dayjs'

type Header = {
  text: string
  value: string
  align?: string
}

const headers: Header[] = [
  { text: '通番', value: 'ConfirmedCasesAttributesCard.table.通番' },
  { text: '確定日', value: 'ConfirmedCasesAttributesCard.table.確定日' },
  { text: '発症日', value: 'ConfirmedCasesAttributesCard.table.発症日' },
  { text: '居住地', value: 'ConfirmedCasesAttributesCard.table.居住地' },
  { text: '年代', value: 'ConfirmedCasesAttributesCard.table.年代' },
  {
    text: '接触歴',
    value: 'ConfirmedCasesAttributesCard.table.接触歴',
    align: 'center',
  },
]

type DataType = {
  id: number
  通番URL: string | null
  確定日: string
  発症日: string | null
  居住地: string | null
  滞在地: string | null
  年代: string | null
  接触歴: string | null
  [key: string]: any
}

type TableDataType = {
  id: DataType['id']
  通番URL: DataType['通番URL']
  確定日: DataType['確定日']
  発症日: DataType['発症日']
  居住地: DataType['居住地']
  滞在地: DataType['滞在地']
  年代: DataType['年代']
  接触歴: DataType['接触歴']
}

type TableDateType = {
  headers: Header[]
  datasets: TableDataType[]
}

/**
 * Format for DataTable component
 *
 * @param data - Raw data
 */
export default function (data: DataType[]): TableDateType {
  const datasets = data
    .map((d) => {
      const occurrenceConfirmedDateDiff = () => {
        if (d['無症状'] === true && d['発症日'] === null) {
          return '無症状'
        } else if (d['無症状'] === false && d['発症日'] === null) {
          return '調査中'
        } else if (d['確定日'] === null || d['発症日'] == null) {
          return '調査中'
        } else {
          return `${dayjs(d['確定日']).diff(d['発症日'], 'day')}日前`
        }
      }
      return {
        id: d.id,
        通番URL: d.url,
        確定日: d['確定日'] ? d['確定日'] : '調査中',
        発症日: occurrenceConfirmedDateDiff(),
        居住地: d['居住地'] ?? '調査中',
        滞在地: d['滞在地'] ?? null,
        年代: d['年代'] ?? '調査中',
        接触歴: d['接触歴'],
      }
    })
    .sort((a, b) => a.id - b.id)
    .reverse()
  return {
    headers,
    datasets,
  }
}
