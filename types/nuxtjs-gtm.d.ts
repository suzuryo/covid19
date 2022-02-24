import 'vue'

declare module 'vue/types/vue' {
  interface Vue {
    $gtm: {
      push(event: { event: string; [key: string]: any }): void
    }
  }
}
