<script lang="ts">
  import { app } from '$lib/stores/app.svelte';
  import type { CharacterSlot } from '$lib/types/character';
  import { ChevronLeft, ChevronRight, User } from 'lucide-svelte';
  import { scale } from 'svelte/transition';

  interface Props {
    slots: CharacterSlot[];
    selectedIndex: number;
    onselect?: (index: number) => void;
  }

  let { slots, selectedIndex, onselect }: Props = $props();

  const visibleStart = $derived(Math.max(0, selectedIndex - 1));
  const visibleSlots = $derived(slots.slice(visibleStart, visibleStart + 3));
</script>

<div class="flex items-center justify-center gap-4">
  <button
    type="button"
    class="flex h-10 w-10 items-center justify-center rounded border border-white/10 bg-black/40 text-white/80 transition hover:bg-white/10 disabled:opacity-30"
    disabled={slots.length <= 1}
    onclick={() => app.prevSlot()}
    aria-label="Previous character"
  >
    <ChevronLeft class="h-5 w-5" />
  </button>

  <div class="flex items-end gap-3">
    {#each visibleSlots as slot, i (visibleStart + i)}
      {@const index = visibleStart + i}
      {@const active = index === selectedIndex}
      <button
        type="button"
        class="group relative flex flex-col items-center transition"
        onclick={() => onselect?.(index)}
        in:scale={{ duration: 200, start: 0.92 }}
      >
        <div
          class={[
            'flex h-24 w-24 items-center justify-center overflow-hidden border bg-black/50 transition',
            active
              ? 'border-white scale-105'
              : 'border-white/15 opacity-70 hover:opacity-100',
          ]}
        >
          {#if slot.type === 'character' && slot.character}
            <div
              class="flex h-full w-full flex-col items-center justify-end bg-gradient-to-t from-black/80 via-black/20 to-transparent p-2"
            >
              <User class="mb-auto mt-6 h-10 w-10 text-white/30" />
              <p class="text-[10px] tracking-wider uppercase">
                {slot.character.firstname}
              </p>
              <p class="text-xs font-semibold uppercase">
                {slot.character.lastname}
              </p>
            </div>
          {:else}
            <div class="flex flex-col items-center gap-2 text-white/50">
              <User class="h-10 w-10" />
              <span class="text-[10px] tracking-[0.2em] uppercase">New Slot</span>
            </div>
          {/if}
        </div>
      </button>
    {/each}
  </div>

  <button
    type="button"
    class="flex h-10 w-10 items-center justify-center rounded border border-white/10 bg-black/40 text-white/80 transition hover:bg-white/10 disabled:opacity-30"
    disabled={slots.length <= 1}
    onclick={() => app.nextSlot()}
    aria-label="Next character"
  >
    <ChevronRight class="h-5 w-5" />
  </button>
</div>
