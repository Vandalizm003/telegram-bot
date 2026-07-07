export type AppScreen = 'selection' | 'create';

export interface NuiMessage<T = unknown> {
  action: string;
  data?: T;
}
