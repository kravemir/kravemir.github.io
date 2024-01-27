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
            <NuxtLink to="/how-to">How to</NuxtLink>
          </li>
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
          <div class="country">🇸🇰 Slovakia</div>
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

body {
  overflow-y: scroll;
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
  max-width: 840px;
  margin: 0 auto;
  padding: 0 20px;
  box-sizing: border-box;
}

nav.main-nav {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  align-items: flex-start;

  padding: 0.75rem 0;
  margin: 1rem 0;

  border-bottom: #879c8b solid 1px;
}

@media (min-width: 640px) {
  nav.main-nav {
    flex-direction:  row;
  }
}

nav.main-nav ul {
  display: flex;

  flex-direction: column;
  align-items: flex-end;

  margin: 0;
  padding: 0;
}

@media (min-width: 640px) {
  nav.main-nav ul {
    flex-direction: row;
    align-items: baseline;
  }
}

nav.main-nav ul li {
  display: block;
}

nav.main-nav ul li + li {
  display: block;
}

@media (min-width: 640px) {
  nav.main-nav ul li + li {
    margin-left: 1.375rem;
  }
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

.about-me .country {
  font-size: 0.75rem;

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
  font-size: 1.75rem;
  margin: 2rem 0 1.5rem;
}

h1 .subtitle {
  display: block;
  font-size: 1rem;
  font-weight: 600;
  margin-top: 0.25rem;
}

h2 {
  margin: 1.25rem 0;
}

h2 a {
  text-decoration: none;
}

h3 a {
  text-decoration: none;
}

p {
  margin-bottom: 0.75rem;
}

li {
  margin: 0.5rem 0;
}

li li {
  margin: 0.375rem 0;
}

li li li {
  margin: 0.25rem;
}

main article figure.page-image {
  display: block;

  margin: auto;
  width: 600px;
  max-width: 100%;
  padding: 1rem 2rem;
  box-sizing: border-box;
}

main article figure.page-image .caption {
  margin-top: 0.5rem;
  font-size: 0.75rem;
  text-align: center;
}

main article img {
  max-width: 100%;
  height: auto;
}

main article .gallery {
  display: grid;
  grid-template-columns: 1fr 1fr;

  gap: 1rem;
  padding: 0.5rem 1rem;

  align-items: flex-start;
}

main article .gallery figure.page-image {
  width: auto;
  box-sizing: border-box;
  height: auto;
  padding: 0;
}

@media (min-width: 640px) {
  main article .gallery {
    grid-template-columns: 1fr 1fr 1fr;

    gap: 2rem;
    padding: 1rem 2rem;
  }
}

main article pre {
  background: #F6F6F6;
  border-radius: 0.25rem;

  display: block;
  overflow: hidden;
}

main article pre code {
  font-size: 0.8125rem;

  display: block;
  overflow-x: auto;

  padding: 1rem;
}

main article code {
  background: #F6F6F6;
  border-radius: 0.125rem;

  font-size: 0.75rem;
  padding: 0.125rem 0.25rem;
}

</style>
<script setup lang="ts">
import 'photoswipe/style.css';
</script>
