<template>
  <div :class="'cover-image'">
    <NuxtPicture
      v-if="coverImageInfo"
      format="webp,jpeg"
      :src="coverImageInfo.src"
      :alt="coverImageInfo.alt"
      :width="coverImageInfo.width"
      :height="coverImageInfo.height"
      sizes="100px"
    />
  </div>
</template>
<script setup lang="ts">
import getCoverImageInfo from "#shared/getCoverImageInfo";

const {document} = defineProps({
  document: {
    type: Object,
    required: true,
    default: {}
  },
})

const coverImageInfo = computed(() => getCoverImageInfo(document))
</script>
<style>
</style>
