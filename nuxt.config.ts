// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: {enabled: true},
  modules: [
    'nuxt-content-assets', // must be before content!
    '@nuxt/content',
    '@nuxt/image',
  ],
  nitro: {
    prerender: {
      routes: ['/sitemap.xml']
    }
  },
  image: {
    dir: '.nuxt/content-assets/public'
  },
  contentAssets: {
    imageSize: 'style attrs'
  }
})
