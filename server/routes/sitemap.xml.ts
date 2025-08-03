import {serverQueryContent} from '#content/server'
import {SitemapStream, streamToPromise} from 'sitemap'

export default defineEventHandler(async (event) => {
  const docs = await serverQueryContent(event).find()

  const sitemap = new SitemapStream({
    hostname: process.env.BASE_URL ?? 'http://localhost/'
  })

  for (const doc of docs) {
    const images = Object.entries(doc.images ?? {}).map(([, image]) => {
      const [, _] = image.image.split('?')
      return ({
        url: image.image.split('?')[0],
        caption: image.alt,
      })
    })

    const imagesFromGallery = Object.entries(doc.imageGallery ?? {}).flatMap(([galleryKey, gallery]) => {
        return gallery
          .filter(item => typeof item === 'object')
          .map(item => {
            const [, _] = item.image.split('?')
            return ({
              url: item.image.split('?')[0],
              caption: item.name,
            })
          })
      }
    )

    sitemap.write({
      url: doc._path + (doc._path == "/" ? "" : "/"),
      img: [...images, ...imagesFromGallery],
    })
  }
  sitemap.end()

  return streamToPromise(sitemap)
})
