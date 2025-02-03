<template>
  <main>
    <div class="container">
      <div class="content">
        <slot/>
      </div>
    </div>
  </main>
</template>
<script setup lang="ts">
import getCoverImageInfo from "#shared/getCoverImageInfo";

const {page} = useContent()
const coverImageInfo = computed(() => getCoverImageInfo(page.value))

if(coverImageInfo.value) {
  useSeoMeta({
    ogImage:  `${process.env.BASE_URL ?? 'http://localhost:3000'}${coverImageInfo.value.src}`,
    ogImageWidth: coverImageInfo.value.width,
    ogImageHeight:  coverImageInfo.value.height
  })
}
</script>
<style scoped>
main > .container > .content {
  border-top: #879c8b solid 1px;
  padding-top: 1rem;
}
</style>
