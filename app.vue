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
    <NuxtPage/>
    <div class="flex-spacer"></div>
    <div class="footer">
      <div class="container">
        <div class="about-me">
          <div class="name" style="margin-bottom: 8px">Miroslav Kravec</div>
          <div class="country" style="margin-bottom: 4px">🇸🇰 Slovakia</div>
          <div class="me-link">
            <NuxtLink to="https://github.com/kravemir" rel="me">github.com</NuxtLink>,
            <NuxtLink to="https://fosstodon.org/@kravemir" rel="me">fosstodon.org</NuxtLink>,
            <NuxtLink to="https://www.flickr.com/people/kravemir/" rel="me">flickr.com</NuxtLink>,
            <NuxtLink to="https://pixabay.com/users/kravemir-27471643/" rel="me">pixabay.com</NuxtLink>,
            <NuxtLink to="https://www.youtube.com/@kravemir" rel="me">youtube.com</NuxtLink>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style></style>
<script setup lang="ts">
import 'photoswipe/style.css';
</script>
