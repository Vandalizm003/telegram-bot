<script lang="ts">
  import { onMount } from 'svelte';
  import type { Snippet } from 'svelte';

  const DESIGN_WIDTH = 1920;
  const DESIGN_HEIGHT = 1080;

  interface Props {
    children?: Snippet;
  }

  let { children }: Props = $props();
  let scale = $state(1);

  function updateScale() {
    scale = Math.min(
      window.innerWidth / DESIGN_WIDTH,
      window.innerHeight / DESIGN_HEIGHT,
    );
  }

  onMount(() => {
    updateScale();
    window.addEventListener('resize', updateScale);

    return () => {
      window.removeEventListener('resize', updateScale);
    };
  });
</script>

<div class="flex h-full w-full items-center justify-center overflow-hidden bg-transparent pointer-events-none">
  <div
    class="pointer-events-auto relative shrink-0"
    style:width="{DESIGN_WIDTH}px"
    style:height="{DESIGN_HEIGHT}px"
    style:transform="scale({scale})"
    style:transform-origin="center center"
  >
    {@render children?.()}
  </div>
</div>
