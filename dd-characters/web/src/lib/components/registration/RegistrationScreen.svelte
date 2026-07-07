<script lang="ts">
  import { BACKSTORY_MAX_LENGTH, GENDERS, MAX_BIRTH_YEAR, MAX_HEIGHT_CM, MAX_NAME_LENGTH, MIN_BIRTH_YEAR, MIN_HEIGHT_CM, MIN_NAME_LENGTH, NATIONALITIES } from '$lib/constants';
  import Dropdown from '$lib/components/ui/Dropdown.svelte';
  import ActionMenuButton from '$lib/components/shared/ActionMenuButton.svelte';
  import BrandLogo from '$lib/components/shared/BrandLogo.svelte';
  import CharacterNameBlock from '$lib/components/shared/CharacterNameBlock.svelte';
  import { app } from '$lib/stores/app.svelte';
  import type { CreateCharacterPayload } from '$lib/types/character';
  import { birthdateInputBounds, isValidBirthdate, isValidHeight, isValidName, sanitizeHeightInput, sanitizeNameInput } from '$lib/utils/validation';
  import { ArrowLeft, UserPlus } from 'lucide-svelte';
  import { fly } from 'svelte/transition';

  let firstname = $state('');
  let lastname = $state('');
  let birthdate = $state('');
  let gender = $state('');
  let nationality = $state('');
  let heightText = $state('170');
  let backstory = $state('');
  let formError = $state('');

  const dateBounds = birthdateInputBounds();
  const genderOptions = GENDERS.map((g) => ({ id: String(g.id), label: g.label }));
  const nationalityOptions = NATIONALITIES.map((n) => ({ id: n, label: n }));
  const nextSlotId = $derived(app.characters.length + 1);

  const previewBackstory = $derived(
    backstory.trim() || 'Your backstory will appear here as you type...',
  );

  function handleBirthdateInput(event: Event) {
    const value = (event.currentTarget as HTMLInputElement).value;
    birthdate = value;

    if (value && !isValidBirthdate(value)) {
      formError = `Date of birth must be between ${MIN_BIRTH_YEAR} and ${MAX_BIRTH_YEAR}.`;
      birthdate = '';
      return;
    }

    formError = '';
  }

  function handleFirstnameInput(event: Event) {
    const input = event.currentTarget as HTMLInputElement;
    firstname = sanitizeNameInput(input.value);
    input.value = firstname;
    formError = '';
  }

  function handleLastnameInput(event: Event) {
    const input = event.currentTarget as HTMLInputElement;
    lastname = sanitizeNameInput(input.value);
    input.value = lastname;
    formError = '';
  }

  function handleHeightInput(event: Event) {
    const input = event.currentTarget as HTMLInputElement;
    heightText = sanitizeHeightInput(input.value);
    input.value = heightText;
    formError = '';
  }

  async function submit() {
    formError = '';

    if (!firstname.trim() || !lastname.trim() || !birthdate || !gender || !nationality) {
      formError = 'Please fill in all required fields.';
      return;
    }

    if (!isValidName(firstname)) {
      formError = `First name must be ${MIN_NAME_LENGTH}-${MAX_NAME_LENGTH} letters.`;
      return;
    }

    if (!isValidName(lastname)) {
      formError = `Last name must be ${MIN_NAME_LENGTH}-${MAX_NAME_LENGTH} letters.`;
      return;
    }

    if (!isValidBirthdate(birthdate)) {
      formError = `Date of birth must be between ${MIN_BIRTH_YEAR} and ${MAX_BIRTH_YEAR}.`;
      return;
    }

    if (!isValidHeight(heightText)) {
      formError = `Height must be between ${MIN_HEIGHT_CM} and ${MAX_HEIGHT_CM} cm.`;
      return;
    }

    const height = Number(heightText.trim());

    const payload: CreateCharacterPayload = {
      firstname: firstname.trim(),
      lastname: lastname.trim(),
      birthdate,
      gender: Number(gender),
      nationality,
      height,
      backstory: backstory.trim() || undefined,
    };

    await app.createCharacter(payload);
  }

  const menuItems = [
    {
      id: 'back',
      label: 'Back',
      sub: 'Return to selection',
      action: () => app.goToSelection(),
      visible: true,
    },
    {
      id: 'create',
      label: 'Create Character',
      sub: 'Save this identity',
      action: () => void submit(),
      visible: true,
    },
  ] as const;
</script>

<div class="pointer-events-none absolute left-1/2 top-8 z-10 -translate-x-1/2 text-white">
    <BrandLogo />
  </div>

  <div class="pointer-events-none absolute left-1/2 top-[5.5rem] z-10 w-full max-w-2xl -translate-x-1/2 px-6 text-center">
    <p class="typewriter-label">BackStory:</p>
    <p class="typewriter-text mt-3 min-h-[3.25rem]">{previewBackstory}</p>
  </div>

  <div class="pointer-events-none absolute inset-x-0 top-1/2 z-10 flex -translate-y-1/2 items-center justify-between px-10 text-white" in:fly={{ y: 8, duration: 300 }}>
    <form
      class="pointer-events-auto w-[300px] shrink-0 space-y-6"
        onsubmit={(e) => {
          e.preventDefault();
          void submit();
        }}
      >
        <CharacterNameBlock
          slotId="+"
          surname={lastname || 'Surname'}
          name={firstname || 'Name'}
          slotLabel="New character slot"
        />

        <dl class="space-y-3 text-sm">
          <div class="flex min-h-[2rem] items-center gap-3">
            <dt class="w-14 shrink-0 text-white/40">First</dt>
            <dd class="flex-1">
              <input
                value={firstname}
                maxlength={MAX_NAME_LENGTH}
                placeholder="John"
                oninput={handleFirstnameInput}
                class="w-full border-b border-white/15 bg-transparent py-1 text-white outline-none placeholder:text-white/25 focus:border-white/40"
              />
            </dd>
          </div>

          <div class="flex min-h-[2rem] items-center gap-3">
            <dt class="w-14 shrink-0 text-white/40">Last</dt>
            <dd class="flex-1">
              <input
                value={lastname}
                maxlength={MAX_NAME_LENGTH}
                placeholder="Doe"
                oninput={handleLastnameInput}
                class="w-full border-b border-white/15 bg-transparent py-1 text-white outline-none placeholder:text-white/25 focus:border-white/40"
              />
            </dd>
          </div>

          <div class="flex min-h-[2rem] items-center gap-3">
            <dt class="w-14 shrink-0 text-white/40">Born</dt>
            <dd class="flex-1">
              <input
                type="date"
                value={birthdate}
                min={dateBounds.min}
                max={dateBounds.max}
                required
                oninput={handleBirthdateInput}
                class="w-full border-b border-white/15 bg-transparent py-1 text-white outline-none focus:border-white/40"
              />
            </dd>
          </div>

          <div class="flex min-h-[2rem] items-center gap-3">
            <dt class="w-14 shrink-0 text-white/40">Gender</dt>
            <dd class="flex-1">
              <Dropdown
                value={gender}
                options={genderOptions}
                placeholder="Select"
                onchange={(value) => (gender = value)}
              />
            </dd>
          </div>

          <div class="flex min-h-[2rem] items-center gap-3">
            <dt class="w-14 shrink-0 text-white/40">Origin</dt>
            <dd class="flex-1">
              <Dropdown
                value={nationality}
                options={nationalityOptions}
                placeholder="Select"
                onchange={(value) => (nationality = value)}
              />
            </dd>
          </div>

          <div class="flex min-h-[2rem] items-center gap-3">
            <dt class="w-14 shrink-0 text-white/40">Height</dt>
            <dd class="flex-1">
              <input
                type="text"
                inputmode="numeric"
                value={heightText}
                placeholder={`${MIN_HEIGHT_CM}-${MAX_HEIGHT_CM}`}
                maxlength={3}
                oninput={handleHeightInput}
                class="w-full border-b border-white/15 bg-transparent py-1 text-white outline-none placeholder:text-white/25 focus:border-white/40"
              />
            </dd>
          </div>

          <div class="flex min-h-[5rem] gap-3 pt-1">
            <dt class="w-14 shrink-0 pt-1 text-white/40">Story</dt>
            <dd class="flex-1">
              <textarea
                bind:value={backstory}
                maxlength={BACKSTORY_MAX_LENGTH}
                rows="3"
                placeholder="Optional backstory..."
                class="w-full resize-none border border-white/10 bg-white/[0.03] px-3 py-2 text-sm text-white outline-none placeholder:text-white/25 focus:border-white/25"
              ></textarea>
              <p class="mt-1 text-xs text-white/35">
                {backstory.length}/{BACKSTORY_MAX_LENGTH}
              </p>
            </dd>
          </div>
        </dl>
      </form>

    <div class="pointer-events-auto w-[220px] shrink-0">
      <nav class="flex flex-col">
        {#each menuItems as item, index (item.id)}
          <ActionMenuButton
            label={item.label}
            sub={item.sub}
            icon={item.id === 'back' ? ArrowLeft : UserPlus}
            showDivider={index < menuItems.length - 1}
            onclick={item.action}
          />
        {/each}
      </nav>
    </div>
  </div>

  <div class="pointer-events-none absolute inset-x-0 bottom-8 z-10 flex flex-col items-center gap-3 text-white">
    {#if formError}
      <p class="max-w-md text-center text-sm text-red-300/90">{formError}</p>
    {/if}
    <p class="text-xs tracking-[0.25em] text-white/35 uppercase">
      Slot {nextSlotId} of {app.config.maxCharacters}
    </p>
  </div>
