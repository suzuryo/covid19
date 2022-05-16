export function isExternal(path: string): boolean {
  return /^https?:\/\//.test(path) || /^extUrl/.test(path)
}

export function isSingleCard(path: string): boolean {
  return path.match(/\/cards\//) !== null
}
