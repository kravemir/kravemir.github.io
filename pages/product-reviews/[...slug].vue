<template>
  <main class="product-review">
    <ContentDoc v-slot="{ doc }">
      <article>
        <h1>
          {{ doc.title + " review" }}
          <span class="subtitle" v-if="doc.subtitle">{{ doc.subtitle }}</span>
        </h1>

        <p v-if="doc.intro">{{doc.intro}}</p>

        <template v-if="doc.notes">
          <div class="proscons">
            <div class="pros">
              <h3>Pros:</h3>
              <ul>
                <li v-for="positiveNote in doc.notes.positive">
                  {{ positiveNote }}
                </li>
              </ul>
            </div>
            <div class="cons">
              <h3>Cons:</h3>
              <ul>
                <li v-for="negativeNote in doc.notes.negative">
                  {{ negativeNote }}
                </li>
              </ul>
            </div>
          </div>
        </template>

        <ContentRenderer :value="doc"/>

        <p class="non-professional-review-disclaimer">
          <strong>Disclaimer: </strong>
          <span>This is a non-professional review based on end-user experience.</span>
        </p>
      </article>
    </ContentDoc>
  </main>
</template>
<script setup lang="ts">
import PhotoSwipeLightbox from 'photoswipe/lightbox';
import { onMounted, onUnmounted } from 'vue'

let lightbox: PhotoSwipeLightbox|null = null

onMounted(() => {
  if (process.browser && !lightbox) {
    lightbox = new PhotoSwipeLightbox({
      gallery: 'main.product-review',
      children: 'div.page-image a',
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
<style scoped>
.proscons {
  display: grid;
  grid-template-columns: 1fr;
}

@media (min-width: 640px) {
  .proscons {
    grid-template-columns: 1fr 1fr;
  }
}

.proscons ul {
  padding-left: 25px;
}

.pros ul {
  list-style-type: "+ ";
}

.cons ul {
  list-style-type: "- ";
}

.non-professional-review-disclaimer {
  margin: 2rem 0;
  font-size: 0.875rem;
}

.non-professional-review-disclaimer strong {
  font-weight: 600;
}
</style>
<script setup lang="ts">
</script>
