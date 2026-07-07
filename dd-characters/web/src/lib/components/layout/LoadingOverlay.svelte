<script lang="ts">
  import { fade, fly } from 'svelte/transition';

  interface Props {
    message?: string;
  }

  let { message = 'Loading...' }: Props = $props();
</script>

<div
  class="pointer-events-none fixed bottom-10 left-1/2 z-[110] -translate-x-1/2"
  transition:fade={{ duration: 200 }}
>
  <div
    class="pointer-events-auto flex items-center gap-3 rounded-full border border-white/15 bg-black/70 px-5 py-3 shadow-xl"
    transition:fly={{ y: 12, duration: 250 }}
  >
    <div
      class="h-5 w-5 animate-spin rounded-full border-2 border-white/20 border-t-white"
    ></div>
    <p class="text-sm text-white/80">{message}</p>
  </div>
</div>
