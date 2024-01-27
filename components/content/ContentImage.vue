<template>
  <figure class="page-image">
    <NuxtLink
      :to="info.src"
      target="_blank"
      :data-pswp-width="info.width"
      :data-pswp-height="info.height"
      class="page-image"
    >
      <NuxtPicture
        format="webp,jpeg"
        :src="info.src"
        :alt="alt"
        :width="info.width"
        :height="info.height"
      />
    </NuxtLink>
    <div class="caption">{{ caption !== undefined ? caption : alt }}</div>
  </figure>
</template>
<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps({
  image: {
    type: String,
    required: true,
  },
  alt: {
    type: String,
    default: '',
  },
  caption: {
    type: String,
    default: undefined,
  },
})

const info = computed(() => {
  const [src, query] = props.image.split('?')
  const params = new URLSearchParams(query)
  return {
    src,
    width: Number(params.get('width')) || undefined,
    height: Number(params.get('height')) || undefined,
  }
})
</script>
