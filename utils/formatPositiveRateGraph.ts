import { convertDateToISO8601Format } from '@/utils/formatDate'

type DataType = {
  diagnosed_date: string
  positive_count: number
}

export type GraphDataType = {
  label: string
  transition: number
  cumulative: number
}

/**
 * Format for *Chart component
 *
 * @param data - Raw data
 */
export default (data: DataType[]) => {
  const graphData: GraphDataType[] = []
  const today = new Date()
  let patSum = 0
  data
    .filter((d) => new Date(d.diagnosed_date) < today)
    .forEach((d) => {
      const subTotal = d.positive_count
      if (!isNaN(subTotal)) {
        patSum += subTotal
        graphData.push({
          label: convertDateToISO8601Format(d.diagnosed_date),
          transition: subTotal,
          cumulative: patSum,
        })
      }
    })
  return graphData
}
