<template>
  <main>
    <ContentDoc v-slot="{ doc }">
      <article>
        <h1>
          <div>How to</div>
          {{ doc.title }}
          <span class="subtitle" v-if="doc.subtitle">{{ doc.subtitle }}</span>
        </h1>

        <p v-if="doc.intro">{{doc.intro}}</p>

        <p class="how-to-risk-disclaimer">
            <strong>Disclaimer: </strong>
            <span>
              This how to is intended for advanced users.
              You should be able to understand what commands are doing, before copy-pasting and executing them.
            </span>
        </p>

        <ContentRenderer :value="doc"/>
      </article>
    </ContentDoc>
  </main>
</template>
<style scoped>
h1 div {
  font-size: 1rem;
  margin-bottom: 0.25rem;
}

.how-to-risk-disclaimer {
  margin: 2rem 24% 2rem 2rem;
  font-size: 0.875rem;
}

.how-to-risk-disclaimer strong {
  font-weight: 600;
}
</style>
<script setup lang="ts">
</script>
