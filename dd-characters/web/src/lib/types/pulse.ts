export type PulseItemType = 'info' | 'alert' | 'event';

export interface PulseItem {
  id: string;
  type: PulseItemType;
  headline: string;
  body: string;
  timestamp: string;
  source?: string;
}
