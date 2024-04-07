<template>
  <BasicLayout>
    <p>Product reviews:</p>
    <ContentList path="/product-reviews/" v-slot="{ list }">
      <ul class="product-review-list">
        <li v-for="productReview in list" :key="productReview._path">
          <NuxtLink :to="productReview._path">{{ productReview.title + (productReview.subtitle ? " - " + productReview.subtitle : "")}}</NuxtLink>
          <div class="intro" v-if="productReview.intro">{{productReview.intro}}</div>
        </li>
      </ul>
    </ContentList>
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
    <p>Product combos:</p>
    <ContentList path="/product-combos/" v-slot="{ list }">
      <ul class="product-combo-list" v-for="productCombo in list" :key="productCombo._path">
        <li  v-for="productCombo in list" :key="productCombo._path">
          <NuxtLink :to="productCombo._path">{{ productCombo.title + (productCombo.subtitle ? " - " + productCombo.subtitle : "")}}</NuxtLink>
          <div class="intro" v-if="productCombo.intro">{{productCombo.intro}}</div>
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

.how-to-list {
  list-style-type: none;
  padding-left: 20px;
}

.how-to-list li .intro {
  margin-top: 0.25rem;

  font-size: 0.875rem;
}

.product-combo-list {
  list-style-type: none;
  padding-left: 20px;
}

.product-combo-list li .intro {
  margin-top: 0.25rem;

  font-size: 0.875rem;
}
</style>
<script setup lang="ts">
import BasicLayout from "~/components/layouts/BasicLayout.vue";
</script>
