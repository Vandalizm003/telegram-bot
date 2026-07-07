export const isEnvBrowser = (): boolean =>
  !(window as Window & { invokeNative?: unknown }).invokeNative;
