import PhotoSwipeLightbox from 'photoswipe/lightbox';
import {onMounted, onUnmounted} from 'vue'

export default function usePhotoSwipe() {
  let lightbox: PhotoSwipeLightbox | null = null

  onMounted(() => {
    if (process.browser && !lightbox) {
      lightbox = new PhotoSwipeLightbox({
        gallery: 'main',
        children: 'figure.page-image a',
        pswpModule: () => import('photoswipe'),
      });
      lightbox.init();
    }
  })

  onUnmounted(() => {
    if (process.browser && lightbox) {
      lightbox.destroy();
      lightbox = null;
    }
  })
}
