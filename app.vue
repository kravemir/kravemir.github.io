<template>
  <div id="page-wrapper">
    <div class="container">
      <nav class="main-nav">
        <ul>
          <li class="home">
            <NuxtLink to="/" class="home">kravemir.org</NuxtLink>
          </li>
        </ul>
        <div class="flex-spacer"></div>
        <ul>
          <li>
            <NuxtLink to="/product-reviews">Product Reviews</NuxtLink>
          </li>
        </ul>
      </nav>
    </div>
    <div>
      <div class="container">
        <NuxtPage/>
      </div>
    </div>
    <div class="flex-spacer"></div>
    <div class="footer">
      <div class="container">
        <div class="about-me">
          <div class="name">Miroslav Kravec</div>
          <div class="me-link">
            <NuxtLink to="https://github.com/kravemir" rel="me">github.com/kravemir</NuxtLink>
          </div>
          <div class="me-link">
            <NuxtLink to="https://hometech.social/@kravemir" rel="me">hometech.social/@kravemir</NuxtLink>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Lora:wght@400;600;700&display=swap');

html, body {
  height: 100%;
  margin: 0;
}

body, #__nuxt, #page-wrapper {
  display: flex;
  flex-direction: column;
  flex-grow: 1;

  align-items: stretch;
}

body,
h1,
h2,
h3,
h4,
h1 a,
h2 a,
h3 a,
h4 a {
  color: #202821;
  font-family: 'Lora', serif;
}

.container {
  display: flex;
  flex-direction: column;

  width: 100%;
  max-width: 720px;
  margin: 0 auto;
  padding: 0 20px;
  box-sizing: border-box;
}

nav.main-nav {
  display: flex;
  flex-direction: row;
  align-items: end;

  padding: 0.75rem 0;
  margin: 1rem 0;

  border-bottom: #879c8b solid 1px;
}

nav.main-nav ul {
  display: flex;
  flex-direction: row;

  margin: 0;
  padding: 0;
}

nav.main-nav ul li {
  display: block;
}

nav.main-nav ul li a,
nav.main-nav ul li a:visited {
  text-decoration: none;

  color: #202821;

  margin: 0.5em 0;
  font-weight: 600;
  font-size: 1.125rem;
}

nav.main-nav ul li.home a {
  font-size: 1.375rem;
}

.footer {
  padding: 1.25rem 0 1.5rem;
  margin: 1rem 0 0;

  background: #cfe6d2;
}

.about-me {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.about-me .name {
  margin-bottom: 0.25rem;
}

.about-me .me-link a,
.about-me .me-link a:visited {
  text-decoration: none;
  font-weight: bold;
  font-size: 0.875rem;

  color: #202821;
}

.flex-spacer {
  flex-grow: 1;
}

h1 {
  font-size: 2rem;
  margin: 2rem 0 1.5rem;
}

h1 .subtitle {
  display: block;
  font-size: 1.25rem;
  font-weight: 600;
  margin-top: 0.25rem;
}

h2 {
  margin: 1.25rem 0;
}

h2 a {
  text-decoration: none;
}

p {
  margin-bottom: 0.75rem;
}

ul li {
  margin-bottom: 0.375rem;
}

main article img {
  max-width: 100%;
  padding: 1rem 2rem;
  box-sizing: border-box;
}
</style>
<script setup lang="ts">
</script>