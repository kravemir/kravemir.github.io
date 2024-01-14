<template>
    <NuxtPicture
            format="avif,webp,jpeg"
            :src="src"
            :alt="alt"
    />
</template>

<script setup lang="ts">
const props = defineProps({
    src: {
        type: String,
        default: ''
    },
    alt: {
        type: String,
        default: ''
    }
})
</script>
