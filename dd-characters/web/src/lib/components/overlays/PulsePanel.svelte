<script lang="ts">
  import SidePanel from './SidePanel.svelte';
  import { pulse } from '$lib/stores/pulse.svelte';
  import type { PulseItemType } from '$lib/types/pulse';
  import { formatPulseTime } from '$lib/utils/format';
  import { cn } from '$lib/utils/cn';
  import { Radio } from 'lucide-svelte';

  interface Props {
    onclose?: () => void;
  }

  let { onclose }: Props = $props();

  function typeLabel(type: PulseItemType): string {
    switch (type) {
      case 'alert':
        return 'Alert';
      case 'event':
        return 'Event';
      default:
        return 'Info';
    }
  }

  function typeClass(type: PulseItemType): string {
    switch (type) {
      case 'alert':
        return 'border-red-500/40 bg-red-500/10 text-red-200';
      case 'event':
        return 'border-amber-500/35 bg-amber-500/10 text-amber-100';
      default:
        return 'border-white/15 bg-white/[0.04] text-white/70';
    }
  }
</script>

<SidePanel title={pulse.station} subtitle="{pulse.frequency} — {pulse.tagline}" {onclose}>
  {#snippet header()}
    <div class="flex items-center gap-3">
      <div class="flex items-center gap-2">
        <span class="relative flex h-2 w-2">
          <span
            class="absolute inline-flex h-full w-full animate-ping rounded-full bg-red-400/70"
          ></span>
          <span class="relative inline-flex h-2 w-2 rounded-full bg-red-500"></span>
        </span>
        <span class="text-[11px] tracking-[0.28em] text-red-300/90 uppercase">On Air</span>
      </div>
      <Radio class="h-3.5 w-3.5 text-white/35" />
      <span class="text-xs text-white/35">Live citywide feed</span>
    </div>
  {/snippet}

  {#if pulse.loading}
    <div class="flex h-40 items-center justify-center">
      <div
        class="h-7 w-7 animate-spin rounded-full border-2 border-white/20 border-t-white"
      ></div>
    </div>
  {:else}
    <div class="space-y-4">
      {#each pulse.items as item, index (item.id)}
        <article
          class={cn(
            'border p-4 transition',
            index === 0 && 'border-white/20 bg-white/[0.03]',
            index !== 0 && 'border-white/10 bg-black/40',
          )}
        >
          <div class="flex flex-wrap items-center gap-2">
            <span
              class={cn(
                'border px-2 py-0.5 text-[10px] tracking-[0.18em] uppercase',
                typeClass(item.type),
              )}
            >
              {typeLabel(item.type)}
            </span>
            <span class="text-[11px] text-white/35">{formatPulseTime(item.timestamp)}</span>
            {#if item.source}
              <span class="text-[11px] text-white/30">— {item.source}</span>
            {/if}
          </div>

          <h4 class="mt-3 text-sm font-medium text-white">{item.headline}</h4>
          <p class="mt-2 text-sm leading-relaxed text-white/60">{item.body}</p>
        </article>
      {/each}
    </div>
  {/if}
</SidePanel>
