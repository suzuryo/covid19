export type SurfaceStyle = {
  strokeColor: string
  fillColor: string
}

type Series = 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G' | 'H' | 'I'

const surfaceStyleA: SurfaceStyle = {
  strokeColor: '#5a8055',
  fillColor: '#1b4d30',
}

const surfaceStyleB: SurfaceStyle = {
  strokeColor: '#5a8055',
  fillColor: '#00a040',
}

const surfaceStyleC: SurfaceStyle = {
  strokeColor: '#5a8055',
  fillColor: '#c5e2c6',
}

const surfaceStyleD: SurfaceStyle = {
  strokeColor: '#1b4d30',
  fillColor: '#cbe1c8',
}

const surfaceStyleE: SurfaceStyle = {
  strokeColor: '#cc7004',
  fillColor: '#cc7004',
}

const surfaceStyleF: SurfaceStyle = {
  strokeColor: '#1b4d30',
  fillColor: '#1b4d30',
}

const surfaceStyleG: SurfaceStyle = {
  strokeColor: '#5a8055',
  fillColor: '#e2eee2',
}

const surfaceStyleH: SurfaceStyle = {
  strokeColor: '#aaaaaa',
  fillColor: '#f0f0f0',
}

const surfaceStyleI: SurfaceStyle = {
  strokeColor: '#666',
  fillColor: '#666',
}

export function getGraphSeriesStyle(seriesLength: number) {
  switch (seriesLength) {
    case 1:
      return [surfaceStyleB]
    case 2:
      return [surfaceStyleA, surfaceStyleC]
    case 3:
      return [surfaceStyleA, surfaceStyleC, surfaceStyleH]
    case 4:
      return [surfaceStyleA, surfaceStyleB, surfaceStyleC, surfaceStyleG]
    case 5:
      return [surfaceStyleA, surfaceStyleB, surfaceStyleC, surfaceStyleH]
    default:
      return [surfaceStyleA, surfaceStyleB, surfaceStyleC]
  }
}

export function getGraphSeriesColor(series: Series) {
  const styles: { [key in Series]: SurfaceStyle } = {
    A: surfaceStyleA,
    B: surfaceStyleB,
    C: surfaceStyleC,
    D: surfaceStyleD,
    E: surfaceStyleE,
    F: surfaceStyleF,
    G: surfaceStyleG,
    H: surfaceStyleH,
    I: surfaceStyleI,
  }
  return styles[series]
}
