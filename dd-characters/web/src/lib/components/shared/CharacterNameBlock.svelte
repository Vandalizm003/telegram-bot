<script lang="ts">
  interface Props {
    slotId?: number | string;
    surname?: string;
    name?: string;
    showSlot?: boolean;
    slotLabel?: string;
  }

  let {
    slotId = '·',
    surname = 'Surname',
    name = 'Name',
    showSlot = true,
    slotLabel,
  }: Props = $props();
</script>

<div class="ui-text-shadow flex items-center gap-4 overflow-visible">
  {#if showSlot}
    <div
      class="relative flex h-11 w-11 shrink-0 items-center justify-center"
      aria-label={slotLabel ?? `Slot ${slotId}`}
    >
      <div
        class="absolute h-8 w-8 rotate-45 border border-white/30 bg-white/[0.07]"
      ></div>
      <span class="relative text-xs font-medium leading-none text-white/90">
        {slotId}
      </span>
    </div>
  {/if}

  <div class="min-w-0">
    <p class="text-[11px] leading-none tracking-[0.32em] text-white/45 uppercase">
      {surname || '—'}
    </p>
    <h1 class="mt-2 text-4xl leading-none font-semibold tracking-tight text-white">
      {name || '—'}
    </h1>
  </div>
</div>
