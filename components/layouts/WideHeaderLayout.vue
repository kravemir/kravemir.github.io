<template>
  <main>
    <div class="header">
      <div class="container">
        <h1>
          <div v-if="titleCategory" class="title-category">{{ titleCategory }}</div>
          {{ title }}
          <span class="subtitle" v-if="subtitle">{{ subtitle }}</span>
        </h1>
        <div class="description" v-if="description">{{description}}</div>
      </div>
    </div>
    <div class="container">
      <div>
        <slot/>
      </div>
    </div>
  </main>
</template>
<script setup lang="ts">
const props = defineProps({
  titleCategory: {
    type: String,
    default: undefined
  },
  title: {
    type: String,
    required: true,
  },
  subtitle: {
    type: String,
    default: undefined,
  },
  description: {
    type: String,
    default: undefined,
  },
})
</script>
<style scoped>
.header {
  background: #F8FBF2;
  padding: 2rem 0;

  border-top: 1px solid #E0F0D0;
  border-bottom: 1px solid #E0F0D0;

  margin-bottom: 1rem;
}

.header .title-category {
  font-size: 1rem;
  margin-bottom: 0.375rem;
}

.header h1 {
  margin: 0;
}

.header .description {
  margin-top:  1rem;
}
</style>
