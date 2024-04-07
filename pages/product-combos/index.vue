<template>
  <BasicLayout>
    <p>Product combos:</p>
    <ContentList path="/product-combos/" v-slot="{ list }">
      <ul class="product-combo-list">
        <li v-for="productCombo in list" :key="productCombo._path">
          <NuxtLink :to="productCombo._path">{{ productCombo.title + (productCombo.subtitle ? " - " + productCombo.subtitle : "")}}</NuxtLink>
          <div class="intro" v-if="productCombo.intro">{{productCombo.intro}}</div>
        </li>
      </ul>
    </ContentList>
  </BasicLayout>
</template>
<style scoped>
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
