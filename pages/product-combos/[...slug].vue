<template>
  <main class="product-combo">
    <ContentDoc v-slot="{ doc }">
      <article>
        <h1>
          {{ doc.title }}
          <span class="subtitle" v-if="doc.subtitle">{{ doc.subtitle }}</span>
        </h1>

        <div class="markdown-content">
          <ContentRenderer :value="doc"/>
        </div>
      </article>
    </ContentDoc>
  </main>
</template>
<script setup lang="ts">
import PhotoSwipeLightbox from 'photoswipe/lightbox';
import {onMounted, onUnmounted} from 'vue'

let lightbox: PhotoSwipeLightbox | null = null

onMounted(() => {
  if (process.browser && !lightbox) {
    lightbox = new PhotoSwipeLightbox({
      gallery: 'main.product-combo',
      children: 'figure.page-image a',
      pswpModule: () => import('photoswipe'),
    });
    lightbox.init();
  }
})

onUnmounted(() => {
  if (process.browser && lightbox) {
    lightbox.destroy();
    lightbox = null;
  }
})
</script>
