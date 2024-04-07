<template>
  <main>
    <div class="container">
      <div class="content">
        <slot/>
      </div>
    </div>
  </main>
</template>
<script setup lang="ts">
</script>
<style scoped>
main > .container > .content {
  border-top: #879c8b solid 1px;
  padding-top: 1rem;
}
</style>
