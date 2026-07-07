<script lang="ts">
  import { app } from '$lib/stores/app.svelte';
  import BrandLogo from '$lib/components/shared/BrandLogo.svelte';
  import CharacterBackstory from './CharacterBackstory.svelte';
  import CharacterCarousel from './CharacterCarousel.svelte';
  import CharacterHero from './CharacterHero.svelte';
  import CharacterSlotActions from './CharacterSlotActions.svelte';
  import MainActionMenu from './MainActionMenu.svelte';
  import { cn } from '$lib/utils/cn';
  import { fly } from 'svelte/transition';

  const character = $derived(app.selectedCharacter);
  const isEmptySlot = $derived(app.selectedSlot?.type === 'empty');

  const placeholderCharacter = {
    id: 0,
    citizenid: '',
    firstname: 'Placeholder',
    lastname: 'Placeholder',
    birthdate: '2000-01-01',
    phone: '000-000-0000',
    gender: 0,
    nationality: '—',
    height: 170,
    job: { name: 'unemployed', label: '—' },
    money: { cash: 0, bank: 0 },
  } as const;
</script>

<div class="pointer-events-none fixed inset-0">
  <div
    class="absolute inset-y-0 left-0 w-[min(46vw,560px)] bg-gradient-to-r from-black/60 via-black/30 to-transparent"
    aria-hidden="true"
  ></div>
  <div
    class="absolute inset-y-0 right-0 w-[min(34vw,380px)] bg-gradient-to-l from-black/60 via-black/30 to-transparent"
    aria-hidden="true"
  ></div>
  <div
    class="absolute inset-x-0 bottom-0 h-52 bg-gradient-to-t from-black/70 via-black/25 to-transparent"
    aria-hidden="true"
  ></div>

  <div
    class="ui-drop-shadow pointer-events-none absolute left-1/2 top-8 z-10 -translate-x-1/2 text-white"
    in:fly={{ y: -10, duration: 300 }}
  >
    <BrandLogo />
  </div>

  <div
    class="ui-text-shadow pointer-events-none absolute left-1/2 top-[5.5rem] z-10 w-full max-w-2xl -translate-x-1/2 px-6 text-center text-white"
    in:fly={{ y: -12, duration: 300 }}
  >
    <CharacterBackstory {character} />
  </div>

  <div
    class="ui-text-shadow pointer-events-auto absolute top-1/2 left-10 z-10 w-[300px] -translate-y-1/2 text-white"
  >
    <div class="relative h-[320px] w-[300px]">
      <div class={cn('absolute inset-0', !character && 'pointer-events-none invisible')}>
        <CharacterHero character={character ?? placeholderCharacter} />
      </div>

      <div
        class={cn(
          'absolute inset-0 w-[300px] space-y-6',
          !isEmptySlot && 'pointer-events-none invisible',
        )}
      >
        <div class="space-y-2">
          <p class="text-[11px] tracking-[0.32em] text-white/70 uppercase">Empty Slot</p>
          <h2 class="text-4xl leading-none font-semibold text-white">New Character</h2>
        </div>
        <p class="text-sm text-white/75">
          Use create below to register a new identity.
        </p>
      </div>
    </div>
  </div>

  <div class="pointer-events-auto absolute top-1/2 right-10 z-10 -translate-y-1/2 text-white">
    <MainActionMenu />
  </div>

  <div
    class="ui-text-shadow pointer-events-auto absolute inset-x-0 bottom-8 z-10 flex flex-col items-center gap-5 text-white"
    in:fly={{ y: 16, duration: 300, delay: 60 }}
  >
    <CharacterCarousel
      slots={app.slots}
      selectedIndex={app.selectedIndex}
      onselect={(index) => app.selectIndex(index)}
    />
    <CharacterSlotActions {isEmptySlot} hasCharacter={Boolean(character)} />
  </div>
</div>
