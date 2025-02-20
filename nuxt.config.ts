// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: {enabled: true},

  experimental: {
    viewTransition: false,
    defaults: {
      nuxtLink: {
        trailingSlash: 'append',
      },
    },
  },

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

  hooks: {
    // https://github.com/davestewart/nuxt-content-assets/issues/49
    // Needed to prevent generate step from hanging. NUXT ^3.7 and above issue
    close: (nuxt) => {
      if (!nuxt.options._prepare)
        process.exit()
    },
  },

  content: {
    documentDriven: true
  },

  contentAssets: {
    imageSize: 'style attrs src',
  },

  extends: [
    'node_modules/nuxt-content-assets/cache',
  ],

  compatibilityDate: '2025-02-01',
})
