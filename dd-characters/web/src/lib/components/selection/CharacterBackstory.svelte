<script lang="ts">
  import type { Character } from '$lib/types/character';
  import { cn } from '$lib/utils/cn';

  interface Props {
    character?: Character | null;
  }

  let { character = null }: Props = $props();

  const backstory = $derived(character?.backstory?.trim() ?? '');
  const hasBackstory = $derived(backstory.length > 0);
</script>

<div class="mx-auto flex min-h-[5.5rem] w-full max-w-2xl items-start justify-center px-6 text-center">
  <div class={cn(!hasBackstory && 'invisible')}>
    <p class="typewriter-label">BackStory:</p>
    <p class="typewriter-text mt-3 min-h-[3.25rem]">
      {hasBackstory ? backstory : 'Placeholder text keeps the layout stable.'}
    </p>
  </div>
</div>
