<template>
  <BasicLayout>
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
  </BasicLayout>
</template>
<script setup lang="ts">
import BasicLayout from "~/components/layouts/BasicLayout.vue";
import usePhotoSwipe from "~/shared/usePhotoSwipe";

usePhotoSwipe();
</script>
