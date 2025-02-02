<template>
  <div class="gallery">
    <ContentImage v-for="item in items_processed"
                  :key="item.image"
                  :image="item.image"
                  :alt="item.alt"
                  :caption="item.caption"/>
  </div>
</template>
<script setup lang="ts">
const {items} = defineProps({
  items: {
    type: Array,
    default: undefined
  },
})

const {page} = useContent()

const items_processed  = items.map(v => (
  typeof v === 'string' ? page.value.images[v] : v
))
</script>
