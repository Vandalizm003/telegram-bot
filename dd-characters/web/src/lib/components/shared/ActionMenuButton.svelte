<script lang="ts">
  import { cn } from '$lib/utils/cn';
  import type { Play } from 'lucide-svelte';

  type MenuIcon = typeof Play;

  interface Props {
    label: string;
    sub: string;
    icon: MenuIcon;
    onclick?: () => void;
    disabled?: boolean;
    showDivider?: boolean;
  }

  let {
    label,
    sub,
    icon: Icon,
    onclick,
    disabled = false,
    showDivider = true,
  }: Props = $props();
</script>

<button
  type="button"
  class={cn(
    'group relative w-full py-3.5 text-left transition-[color,transform] duration-200 ease-out',
    showDivider && 'border-b border-white/10',
  )}
  tabindex={0}
  aria-hidden={false}
  {disabled}
  {onclick}
>
  <span
    class="absolute top-1/2 left-0 h-8 w-px -translate-y-1/2 bg-white/70 opacity-0 transition-opacity duration-200 group-hover:opacity-100 group-focus-visible:opacity-100"
  ></span>

  <div
    class="flex items-start gap-3 pl-3 transition-transform duration-200 ease-out group-hover:translate-x-1 group-focus-visible:translate-x-1"
  >
    <Icon
      class="mt-0.5 h-4 w-4 shrink-0 text-white/50 transition-colors duration-200 group-hover:text-white group-focus-visible:text-white"
    />
    <div>
      <p
        class="text-sm font-medium text-white/90 transition-colors duration-200 group-hover:text-white group-focus-visible:text-white"
      >
        {label}
      </p>
      <p
        class="mt-0.5 text-xs text-white/40 transition-colors duration-200 group-hover:text-white/60 group-focus-visible:text-white/60"
      >
        {sub}
      </p>
    </div>
  </div>
</button>
