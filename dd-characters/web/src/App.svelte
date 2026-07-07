<script lang="ts">
  import { onMount } from 'svelte';
  import { fetchNui } from '$lib/nui/fetch';
  import CinematicIntro from '$lib/components/layout/CinematicIntro.svelte';
  import LoadingOverlay from '$lib/components/layout/LoadingOverlay.svelte';
  import RegistrationScreen from '$lib/components/registration/RegistrationScreen.svelte';
  import CharacterSelectionScreen from '$lib/components/selection/CharacterSelectionScreen.svelte';
  import { startBrowserPreview } from '$lib/dev/browser-preview';
  import CodexPanel from '$lib/components/overlays/CodexPanel.svelte';
  import PulsePanel from '$lib/components/overlays/PulsePanel.svelte';
  import { setupNuiLifecycle } from '$lib/nui/lifecycle';
  import { app } from '$lib/stores/app.svelte';
  import { isEnvBrowser } from '$lib/utils/misc';

  const mainUiOpacity = $derived(app.introActive && !app.introRevealing ? 0 : 1);
  const mainUiInteractive = $derived(!app.introActive && !app.overlay);

  onMount(() => {
    const stopBrowserPreview = startBrowserPreview();
    const teardown = setupNuiLifecycle();

    void fetchNui<{ brand?: { name?: string; logoUrl?: string | false } }>(
      'ui:ready',
    ).then((payload) => {
      app.setBrand(payload.brand);
    });

    if (isEnvBrowser()) {
      void app.beginIntro();
    }

    return () => {
      stopBrowserPreview();
      teardown();
    };
  });
</script>

{#if app.visible}
  <CinematicIntro active={app.introActive} revealing={app.introRevealing} />

  <div
    class="fixed inset-0 z-10 pointer-events-none transition-opacity duration-[900ms] ease-out"
    class:pointer-events-auto={mainUiInteractive}
    style:opacity={mainUiOpacity}
  >
    {#if app.screen === 'selection'}
      <CharacterSelectionScreen />
    {:else if app.screen === 'create'}
      <RegistrationScreen />
    {/if}
  </div>

  {#if app.overlay && !app.introActive}
    <div class="pointer-events-auto fixed inset-0 z-[60]">
      {#if app.overlay === 'codex'}
        <CodexPanel onclose={() => app.closeOverlay()} />
      {:else if app.overlay === 'pulse'}
        <PulsePanel onclose={() => app.closeOverlay()} />
      {/if}
    </div>
  {/if}

  {#if app.loading && !app.introActive}
    <LoadingOverlay message={app.loadingMessage} />
  {/if}
{/if}
