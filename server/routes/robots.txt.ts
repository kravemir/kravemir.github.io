
export default defineEventHandler((event) => {
  setHeader(event, "content-type", "plaintext");

  return [
    'User-agent: *',
    'Disallow:',
    '',
    `Sitemap: ${process.env.BASE_URL ?? 'http://localhost'}/sitemap.xml`
  ].join("\n") + "\n"
})
