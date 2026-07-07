import { app } from '$lib/stores/app.svelte';
import { isEnvBrowser } from '$lib/utils/misc';

const setBrowserClassNames = (enabled: boolean): void => {
  document.documentElement.classList.toggle('env-browser', enabled);
  document.body.classList.toggle('env-browser', enabled);
};

export function startBrowserPreview(): () => void {
  if (!import.meta.env.DEV || !isEnvBrowser()) {
    return () => undefined;
  }

  setBrowserClassNames(true);
  app.setVisible(true);

  return () => {
    setBrowserClassNames(false);
  };
}
