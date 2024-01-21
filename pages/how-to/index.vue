<template>
  <main>
    <p>How to pages:</p>
    <ContentList path="/how-to/" v-slot="{ list }">
      <ul class="how-to-list" v-for="howTo in list" :key="howTo._path">
        <li  v-for="howTo in list" :key="howTo._path">
          <NuxtLink :to="howTo._path">{{ howTo.title + (howTo.subtitle ? " - " + howTo.subtitle : "")}}</NuxtLink>
          <div class="intro" v-if="howTo.intro">{{howTo.intro}}</div>
        </li>
      </ul>
    </ContentList>
  </main>
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
