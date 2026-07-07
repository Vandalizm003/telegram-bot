<script lang="ts">
  import SidePanel from './SidePanel.svelte';
  import { codex } from '$lib/stores/codex.svelte';
  import type { CodexCategory } from '$lib/types/codex';
  import { cn } from '$lib/utils/cn';

  interface Props {
    onclose?: () => void;
  }

  let { onclose }: Props = $props();

  let activeCategory = $state<CodexCategory>('onboarding');

  const categorySections = $derived(codex.sectionsForCategory(activeCategory));

  $effect(() => {
    const first = categorySections[0];
    if (first && !categorySections.some((s) => s.id === codex.selectedId)) {
      codex.select(first.id);
    }
  });
</script>

<SidePanel title="Codex" subtitle="Lore, rules & onboarding" {onclose}>
  {#snippet header()}
    <div class="flex gap-2">
      {#each codex.categories as category (category.id)}
        <button
          type="button"
          class={cn(
            'border px-3 py-1.5 text-xs tracking-[0.15em] uppercase transition',
            activeCategory === category.id
              ? 'border-white/30 bg-white/[0.06] text-white'
              : 'border-white/10 text-white/45 hover:border-white/20 hover:text-white/70',
          )}
          onclick={() => (activeCategory = category.id)}
        >
          {category.label}
        </button>
      {/each}
    </div>
  {/snippet}

  {#if codex.loading}
    <div class="flex h-40 items-center justify-center">
      <div
        class="h-7 w-7 animate-spin rounded-full border-2 border-white/20 border-t-white"
      ></div>
    </div>
  {:else}
    <div class="grid min-h-0 gap-6 md:grid-cols-[9rem_minmax(0,1fr)]">
      <nav class="flex flex-col gap-1">
        {#each categorySections as section (section.id)}
          <button
            type="button"
            class={cn(
              'border-l-2 py-2 pl-3 text-left text-sm transition',
              codex.selectedId === section.id
                ? 'border-white text-white'
                : 'border-transparent text-white/45 hover:text-white/75',
            )}
            onclick={() => codex.select(section.id)}
          >
            {section.title}
          </button>
        {/each}
      </nav>

      {#if codex.selectedSection}
        <article class="min-w-0">
          <h3 class="text-xl font-semibold text-white">{codex.selectedSection.title}</h3>
          <p class="typewriter-text mt-4 text-[0.95rem] leading-relaxed">
            {codex.selectedSection.content}
          </p>
        </article>
      {/if}
    </div>
  {/if}
</SidePanel>
