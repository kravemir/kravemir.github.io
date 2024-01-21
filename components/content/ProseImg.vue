<template>
  <div class="page-image">
    <NuxtLink
      :to="src"
      target="_blank"
      :data-pswp-width="width"
      :data-pswp-height="height"
      class="page-image"
    >
      <NuxtPicture
        format="webp,jpeg"
        :src="src"
        :alt="alt"
        :width="width"
        :height="height"
      />
    </NuxtLink>
    <div class="caption">{{ caption !== '' ? caption : alt }}</div>
  </div>
</template>

<script setup lang="ts">
defineProps({
  src: {
    type: String,
    default: ''
  },
  alt: {
    type: String,
    default: ''
  },
  caption: {
    type: [String],
    default: ''
  },
  width: {
    type: [String, Number],
    default: undefined
  },
  height: {
    type: [String, Number],
    default: undefined
  }
})
</script>
