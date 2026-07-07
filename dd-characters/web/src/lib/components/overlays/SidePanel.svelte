<script lang="ts">
  import { X } from 'lucide-svelte';
  import { fade, fly } from 'svelte/transition';
  import type { Snippet } from 'svelte';

  interface Props {
    title: string;
    subtitle?: string;
    onclose?: () => void;
    children: Snippet;
    header?: Snippet;
  }

  let { title, subtitle = '', onclose, children, header }: Props = $props();

  function handleKeydown(event: KeyboardEvent) {
    if (event.key === 'Escape') onclose?.();
  }
</script>

<svelte:window onkeydown={handleKeydown} />

<div
  class="pointer-events-auto fixed inset-0 z-50 flex items-center justify-end bg-black/55 p-8 backdrop-blur-[2px]"
  role="presentation"
  transition:fade={{ duration: 200 }}
  onclick={(e) => e.target === e.currentTarget && onclose?.()}
>
  <div
    class="flex h-full max-h-[720px] w-full max-w-[640px] flex-col border border-white/10 bg-black/90 shadow-2xl"
    role="dialog"
    aria-modal="true"
    aria-label={title}
    transition:fly={{ x: 40, duration: 280 }}
  >
    <div class="flex items-start justify-between gap-4 border-b border-white/10 px-6 py-5">
      <div>
        <p class="text-[11px] tracking-[0.35em] text-white/40 uppercase">{title}</p>
        {#if subtitle}
          <p class="mt-1 text-sm text-white/55">{subtitle}</p>
        {/if}
      </div>

      <button
        type="button"
        class="flex h-8 w-8 items-center justify-center border border-white/10 text-white/60 transition hover:border-white/25 hover:text-white"
        aria-label="Close"
        onclick={() => onclose?.()}
      >
        <X class="h-4 w-4" />
      </button>
    </div>

    {#if header}
      <div class="border-b border-white/10 px-6 py-3">
        {@render header()}
      </div>
    {/if}

    <div class="min-h-0 flex-1 overflow-y-auto px-6 py-5">
      {@render children()}
    </div>
  </div>
</div>
