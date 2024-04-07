<template>
  <BasicLayout>
    <ContentDoc />
    <hr />
    <p>Product reviews:</p>
    <ContentList path="/product-reviews/" v-slot="{ list }">
      <ul class="product-review-list">
        <li v-for="productReview in list" :key="productReview._path">
          <NuxtLink :to="productReview._path">{{ productReview.title + (productReview.subtitle ? " - " + productReview.subtitle : "")}}</NuxtLink>
          <div class="intro" v-if="productReview.intro">{{productReview.intro}}</div>
        </li>
      </ul>
    </ContentList>
  </BasicLayout>
</template>
<style scoped>
.product-review-list {
  list-style-type: none;
  padding-left: 20px;
}

.product-review-list li .intro {
  margin-top: 0.25rem;

  font-size: 0.875rem;
}
</style>
<script setup lang="ts">
import BasicLayout from "~/components/layouts/BasicLayout.vue";
</script>
