<template>
  <BasicLayout>
    <ContentDoc v-slot="{ doc }">
      <article>
        <h1>
          {{ doc.title + " review" }}
          <span class="subtitle" v-if="doc.subtitle">{{ doc.subtitle }}</span>
        </h1>

        <p v-if="doc.intro">{{ doc.intro }}</p>

        <template v-if="doc.notes">
          <div class="proscons">
            <div class="pros">
              <h3>Pros:</h3>
              <ul>
                <li v-for="positiveNote in doc.notes.positive">
                  {{ positiveNote }}
                </li>
              </ul>
            </div>
            <div class="cons">
              <h3>Cons:</h3>
              <ul>
                <li v-for="negativeNote in doc.notes.negative">
                  {{ negativeNote }}
                </li>
              </ul>
            </div>
          </div>
        </template>

        <div class="markdown-content">
          <ContentRenderer :value="doc"/>
        </div>

        <p class="non-professional-review-disclaimer">
          <strong>Disclaimer: </strong>
          <span>This is a non-professional review based on end-user experience.</span>
        </p>
      </article>
    </ContentDoc>
  </BasicLayout>
</template>
<script setup lang="ts">
import BasicLayout from "~/components/layouts/BasicLayout.vue";
import usePhotoSwipe from "~/shared/usePhotoSwipe";

usePhotoSwipe();
</script>
<style scoped>
.proscons {
  display: grid;
  grid-template-columns: 1fr;
}

@media (min-width: 640px) {
  .proscons {
    grid-template-columns: 1fr 1fr;
  }
}

.proscons ul {
  padding-left: 25px;
}

.pros ul {
  list-style-type: "+ ";
}

.cons ul {
  list-style-type: "- ";
}

.non-professional-review-disclaimer {
  margin: 2rem 0;
  font-size: 0.875rem;
}

.non-professional-review-disclaimer strong {
  font-weight: 600;
}
</style>
