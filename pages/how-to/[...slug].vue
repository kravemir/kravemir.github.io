<template>
  <ContentDoc v-slot="{ doc }">
    <WideHeaderLayout
      title-category="How to"
      v-bind:title="doc.title"
      v-bind:subtitle="doc.subtitle"
      v-bind:description="doc.description"
    >
      <article>
        <div v-if="doc.intro">
          <p v-for="p in (doc.intro.split('\n\n'))">
            {{ p }}
          </p>
        </div>

        <p class="how-to-risk-disclaimer">
          <strong>Disclaimer: </strong>
          <span>
              This how to is intended for advanced users.
              You should be able to understand what commands are doing, before copy-pasting and executing them.
            </span>
        </p>

        <ContentRenderer :value="doc"/>
      </article>
    </WideHeaderLayout>
  </ContentDoc>
</template>
<style scoped>

.how-to-risk-disclaimer {
  margin: 2rem 24% 2rem 2rem;
  font-size: 0.875rem;
}

.how-to-risk-disclaimer strong {
  font-weight: 600;
}
</style>
<script setup lang="ts">
import WideHeaderLayout from "~/components/layouts/WideHeaderLayout.vue";
import usePhotoSwipe from "~/shared/usePhotoSwipe";

usePhotoSwipe();
</script>
