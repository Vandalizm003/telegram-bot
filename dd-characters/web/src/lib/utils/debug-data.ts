import { isEnvBrowser } from './misc';

export const debugData = <P extends Record<string, unknown>>(
  events: { action: string; data: P }[],
  timer = 1000,
): void => {
  if (!isEnvBrowser()) {
    return;
  }

  for (const event of events) {
    setTimeout(() => {
      window.dispatchEvent(
        new MessageEvent('message', {
          data: {
            action: event.action,
            ...event.data,
          },
        }),
      );
    }, timer);
  }
};
