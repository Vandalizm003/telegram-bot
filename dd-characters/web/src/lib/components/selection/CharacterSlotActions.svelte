<script lang="ts">
  import { app } from '$lib/stores/app.svelte';
  import { cn } from '$lib/utils/cn';
  import { Trash2, UserPlus } from 'lucide-svelte';

  interface Props {
    isEmptySlot?: boolean;
    hasCharacter?: boolean;
  }

  let { isEmptySlot = false, hasCharacter = false }: Props = $props();

  const showCreate = $derived(isEmptySlot && app.canCreateCharacter);
  const showDelete = $derived(hasCharacter);
</script>

<div class="relative h-11 w-[190px] shrink-0">
  <button
    type="button"
    class={cn(
      'absolute inset-0 inline-flex items-center justify-center gap-2 border border-white/15 bg-white/[0.04] px-5 text-sm text-white transition hover:border-white/30 hover:bg-white/[0.08]',
      !showCreate && 'pointer-events-none invisible',
    )}
    tabindex={showCreate ? 0 : -1}
    aria-hidden={!showCreate}
    disabled={!showCreate}
    onclick={() => app.openRegistration()}
  >
    <UserPlus class="h-4 w-4 text-white/70" />
    Create Character
  </button>

  <button
    type="button"
    class={cn(
      'absolute inset-0 inline-flex items-center justify-center gap-2 border border-red-500/30 bg-red-500/10 px-5 text-sm text-red-100 transition hover:border-red-500/50 hover:bg-red-500/15',
      !showDelete && 'pointer-events-none invisible',
    )}
    tabindex={showDelete ? 0 : -1}
    aria-hidden={!showDelete}
    disabled={!showDelete}
    onclick={() => app.deleteSelectedCharacter()}
  >
    <Trash2 class="h-4 w-4" />
    Delete Character
  </button>
</div>
