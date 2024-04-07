<template>
  <BasicLayout>
    <p>How to pages:</p>
    <ContentList path="/how-to/" v-slot="{ list }">
      <ul class="how-to-list">
        <li v-for="howTo in list" :key="howTo._path">
          <NuxtLink :to="howTo._path">{{ howTo.title + (howTo.subtitle ? " - " + howTo.subtitle : "")}}</NuxtLink>
          <div class="intro" v-if="howTo.description">{{howTo.description}}</div>
          <div class="intro" v-if="howTo.intro && !howTo.description">{{howTo.intro}}</div>
        </li>
      </ul>
    </ContentList>
  </BasicLayout>
</template>
<style scoped>
.how-to-list {
  list-style-type: none;
  padding-left: 20px;
}

.how-to-list li .intro {
  margin-top: 0.25rem;

  font-size: 0.875rem;
}
</style>
<script setup lang="ts">
import BasicLayout from "~/components/layouts/BasicLayout.vue";
</script>
