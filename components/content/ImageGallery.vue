<template>
  <div class="gallery">
    <ContentImage v-for="item in items"
                  :key="item.image"
                  :image="item.image"
                  :alt="item.alt"
                  :caption="item.caption"/>
  </div>
</template>
<script setup lang="ts">
defineProps({
  items: {
    type: Array,
    default: undefined
  },
})
</script>
