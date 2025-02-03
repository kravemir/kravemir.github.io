<template>
  <BasicLayout>
    <p>Product reviews:</p>
    <ContentList path="/product-reviews/" v-slot="{ list }">
      <ul class="generic-link-list product-review-list">
        <li v-for="productReview in list" :key="productReview._path">
          <ListItemCoverImageThumbnail :document="productReview"/>
          <NuxtLink :to="productReview._path">
            {{ productReview.title }}
            <span class="subtitle" v-if="productReview.subtitle">{{ productReview.subtitle }}</span>
          </NuxtLink>
          <div class="intro" v-if="productReview.intro">{{ productReview.intro }}</div>
        </li>
      </ul>
    </ContentList>
    <p>How to pages:</p>
    <ContentList path="/how-to/" v-slot="{ list }">
      <ul class="generic-link-list how-to-list">
        <li v-for="howTo in list" :key="howTo._path">
          <ListItemCoverImageThumbnail :document="howTo"/>
          <div>
            <NuxtLink :to="howTo._path">
              {{ howTo.title }}
              <span class="subtitle" v-if="howTo.subtitle">{{ howTo.subtitle }}</span>
            </NuxtLink>
            <div class="intro" v-if="howTo.description">{{ howTo.description }}</div>
            <div class="intro" v-if="howTo.intro && !howTo.description">{{ howTo.intro }}</div>
          </div>
        </li>
      </ul>
    </ContentList>
    <p>Product combos:</p>
    <ContentList path="/product-combos/" v-slot="{ list }">
      <ul class="generic-link-list product-combo-list" v-for="productCombo in list" :key="productCombo._path">
        <li v-for="productCombo in list" :key="productCombo._path">
          <ListItemCoverImageThumbnail :document="productCombo"/>
          <NuxtLink :to="productCombo._path">
            {{ productCombo.title }}
            <span class="subtitle" v-if="productCombo.subtitle">{{ productCombo.subtitle }}</span>
          </NuxtLink>
          <div class="intro" v-if="productCombo.intro">{{ productCombo.intro }}</div>
        </li>
      </ul>
    </ContentList>
  </BasicLayout>
</template>
<style scoped>
.product-review-list li .intro {
  margin-top: 0.25rem;

  font-size: 0.875rem;
}

.how-to-list li .intro {
  margin-top: 0.25rem;

  font-size: 0.875rem;
}

.product-combo-list li .intro {
  margin-top: 0.25rem;

  font-size: 0.875rem;
}
</style>
<script setup lang="ts">
import BasicLayout from "~/components/layouts/BasicLayout.vue";
</script>
