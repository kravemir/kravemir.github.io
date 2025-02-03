<template>
  <BasicLayout>
    <p>How to pages:</p>
    <ContentList path="/how-to/" v-slot="{ list }">
      <ul class="generic-link-list how-to-list">
        <li v-for="howTo in list" :key="howTo._path">
          <ListItemCoverImageThumbnail :document="howTo"/>
          <NuxtLink :to="howTo._path">
            {{ howTo.title}}
            <span class="subtitle" v-if="howTo.subtitle">{{howTo.subtitle}}</span>
          </NuxtLink>
          <div class="intro" v-if="howTo.description">{{howTo.description}}</div>
          <div class="intro" v-if="howTo.intro && !howTo.description">{{howTo.intro}}</div>
        </li>
      </ul>
    </ContentList>
  </BasicLayout>
</template>
<style scoped>
.how-to-list li .intro {
  margin-top: 0.25rem;

  font-size: 0.875rem;
}
</style>
<script setup lang="ts">
import BasicLayout from "~/components/layouts/BasicLayout.vue";
</script>
