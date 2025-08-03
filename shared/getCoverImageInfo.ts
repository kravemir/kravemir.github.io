export default function getCoverImageInfo(document) {
  const coverImage = (document.images ?? {})[document.coverImage]

  if (!coverImage) {
    return null
  }

  const [src, query] = coverImage.image.split('?')
  const params = new URLSearchParams(query)
  return {
    src,
    alt: coverImage.alt,
    width: Number(params.get('width')) || undefined,
    height: Number(params.get('height')) || undefined,
  }
}
