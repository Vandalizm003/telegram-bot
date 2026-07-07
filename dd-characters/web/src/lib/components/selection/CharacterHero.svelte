<script lang="ts">
  import type { Character } from '$lib/types/character';
  import CharacterNameBlock from '$lib/components/shared/CharacterNameBlock.svelte';
  import CharacterTimeline from '$lib/components/shared/CharacterTimeline.svelte';
  import { formatCurrency, formatDate } from '$lib/utils/format';

  interface Props {
    character: Character;
  }

  let { character }: Props = $props();

  const details = $derived([
    { label: 'Born', value: formatDate(character.birthdate) },
    { label: 'Phone', value: character.phone },
    { label: 'Job', value: character.job.label },
    { label: 'Cash', value: formatCurrency(character.money.cash) },
    { label: 'Bank', value: formatCurrency(character.money.bank) },
    { label: 'Origin', value: character.nationality },
    { label: 'Sign', value: character.zodiac ?? '—' },
  ]);
</script>

<div class="w-[300px] shrink-0 space-y-6 ui-text-shadow">
  <CharacterNameBlock
    slotId={character.id}
    surname={character.lastname}
    name={character.firstname}
  />

  <CharacterTimeline
    lastPlayed={character.lastPlayed}
    playtimeHours={character.playtimeHours}
  />

  <dl class="space-y-2 text-sm">
    {#each details as item}
      <div class="flex min-h-[1.25rem] gap-3">
        <dt class="w-14 shrink-0 text-white/40">{item.label}</dt>
        <dd class="text-white/85">{item.value}</dd>
      </div>
    {/each}
  </dl>
</div>
