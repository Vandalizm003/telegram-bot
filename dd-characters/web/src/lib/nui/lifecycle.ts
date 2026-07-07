import { app } from '$lib/stores/app.svelte';
import type { NuiMessage } from '$lib/types/nui';

export const setupNuiLifecycle = (): (() => void) => {
  const handleMessage = (event: MessageEvent<NuiMessage>) => {
    const { action, data } = event.data ?? {};

    if (!action) return;

    if (action === 'setVisible') {
      app.setVisible(Boolean((data as { visible?: boolean })?.visible));
      return;
    }

    if (action === 'sessionIntro' || action === 'sessionStart') {
      void app.beginIntro();
      return;
    }

    if (action === 'previewReady') {
      app.markPreviewReady();
      return;
    }

    if (action === 'setLoading') {
      const payload = data as { loading?: boolean; message?: string };
      app.setLoading(Boolean(payload.loading), payload.message ?? '');
      return;
    }

    if (action === 'refreshCharacters') {
      void app.loadCharacters();
    }
  };

  const handleKeydown = (event: KeyboardEvent) => {
    if (event.key === 'Escape' && app.screen === 'create') {
      app.goToSelection();
    }
  };

  window.addEventListener('message', handleMessage);
  window.addEventListener('keydown', handleKeydown);

  return () => {
    window.removeEventListener('message', handleMessage);
    window.removeEventListener('keydown', handleKeydown);
  };
};
