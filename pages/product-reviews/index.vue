<template>
  <main>
    <ContentDoc />
    <hr />
    <p>Product reviews:</p>
    <ContentList path="/product-reviews/" v-slot="{ list }">
      <ul class="product-review-list" v-for="productReview in list" :key="productReview._path">
        <li  v-for="productReview in list" :key="productReview._path">
          <NuxtLink :to="productReview._path">{{ productReview.title + (productReview.intro ? " - " + productReview.subtitle : "")}}</NuxtLink>
          <div class="intro" v-if="productReview.intro">{{productReview.intro}}</div>
        </li>
      </ul>
    </ContentList>
  </main>
</template>
<style>
.product-review-list {
  list-style-type: none;
  padding-left: 20px;
}

.product-review-list li .intro {
  margin-top: 0.25rem;

  font-size: 0.875rem;
}
</style>