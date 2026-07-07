<script lang="ts">
  import { app } from '$lib/stores/app.svelte';
  import { cn } from '$lib/utils/cn';

  interface Props {
    class?: string;
    size?: 'sm' | 'lg';
  }

  let { class: className = '', size = 'sm' }: Props = $props();
  let logoFailed = $state(false);

  const showImage = $derived(Boolean(app.brandLogoUrl) && !logoFailed);
</script>

<div class={cn('flex flex-col items-center gap-2 ui-text-shadow', className)}>
  {#if showImage}
    <img
      src={app.brandLogoUrl ?? ''}
      alt={app.brandName}
      class={cn(
        'w-auto object-contain',
        size === 'lg' ? 'max-h-28 max-w-[320px]' : 'max-h-14 max-w-[180px]',
      )}
      onerror={() => {
        logoFailed = true;
      }}
    />
  {:else}
    <div
      class={cn(
        'flex flex-col items-center justify-center text-center',
        size === 'lg' ? 'gap-2 px-4' : 'gap-1 px-2',
      )}
    >
      <span
        class={cn(
          'font-semibold tracking-[0.28em] text-white uppercase',
          size === 'lg' ? 'text-3xl md:text-4xl' : 'text-sm',
        )}
      >
        {app.brandName}
      </span>
      {#if size === 'lg'}
        <span class="text-[10px] tracking-[0.42em] text-white/40 uppercase">
          Character Selection
        </span>
      {/if}
    </div>
  {/if}
</div>
