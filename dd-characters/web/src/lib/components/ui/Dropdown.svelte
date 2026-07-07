<script lang="ts">
  import { Check, ChevronDown } from 'lucide-svelte';
  import { cn } from '$lib/utils/cn';

  interface Option {
    id: string;
    label: string;
  }

  interface Props {
    value?: string;
    options?: Option[];
    placeholder?: string;
    class?: string;
    onchange?: (value: string) => void;
  }

  let {
    value = '',
    options = [],
    placeholder = 'Select',
    class: className = '',
    onchange,
  }: Props = $props();

  let open = $state(false);
  let container: HTMLDivElement | undefined = $state();

  const selected = $derived(
    options.find((option) => option.id === value) ?? null,
  );

  function select(id: string) {
    onchange?.(id);
    open = false;
  }

  function handleWindowClick(event: MouseEvent) {
    if (!open || !container) return;

    if (!container.contains(event.target as Node)) {
      open = false;
    }
  }
</script>

<svelte:window onclick={handleWindowClick} />

<div bind:this={container} class={cn('relative', className)}>
  <button
    type="button"
    aria-expanded={open}
    aria-haspopup="listbox"
    class={cn(
      'flex w-full items-center justify-between border-b bg-transparent py-1 text-left text-sm outline-none transition',
      open ? 'border-white/40' : 'border-white/15 hover:border-white/30',
    )}
    onclick={() => (open = !open)}
  >
    <span class={selected ? 'text-white' : 'text-white/25'}>
      {selected?.label ?? placeholder}
    </span>
    <ChevronDown
      class={cn('h-3.5 w-3.5 shrink-0 text-white/40 transition', open && 'rotate-180')}
    />
  </button>

  {#if open}
    <div
      role="listbox"
      tabindex="-1"
      class="absolute top-[calc(100%+0.25rem)] right-0 left-0 z-50 max-h-44 overflow-y-auto border border-white/10 bg-black/95 shadow-xl"
    >
      {#each options as option, index (option.id)}
        <button
          type="button"
          role="option"
          aria-selected={option.id === value}
          class={cn(
            'flex w-full items-center justify-between px-2 py-2 text-left text-sm transition hover:bg-white/[0.04]',
            index < options.length - 1 && 'border-b border-white/5',
            option.id === value ? 'text-white' : 'text-white/70',
          )}
          onclick={() => select(option.id)}
        >
          <span>{option.label}</span>
          {#if option.id === value}
            <Check class="h-3.5 w-3.5 text-white/70" />
          {/if}
        </button>
      {/each}
    </div>
  {/if}
</div>
