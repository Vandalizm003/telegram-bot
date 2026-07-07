import { mockPulseItems, mockPulseStation } from '$lib/mocks/pulse';
import { fetchNui } from '$lib/nui/fetch';
import type { PulseItem } from '$lib/types/pulse';

class PulseStore {
  station = $state(mockPulseStation.station);
  frequency = $state(mockPulseStation.frequency);
  tagline = $state(mockPulseStation.tagline);
  items = $state<PulseItem[]>([]);
  loading = $state(false);

  async load(): Promise<void> {
    this.loading = true;

    try {
      const payload = await fetchNui<{
        station: string;
        frequency: string;
        tagline: string;
        items: PulseItem[];
      }>('getPulse');

      this.station = payload.station || mockPulseStation.station;
      this.frequency = payload.frequency || mockPulseStation.frequency;
      this.tagline = payload.tagline || mockPulseStation.tagline;
      this.items = payload.items?.length ? payload.items : mockPulseItems;
    } catch {
      this.station = mockPulseStation.station;
      this.frequency = mockPulseStation.frequency;
      this.tagline = mockPulseStation.tagline;
      this.items = mockPulseItems;
    } finally {
      this.loading = false;
    }
  }

  reset(): void {
    this.items = [];
    this.loading = false;
  }
}

export const pulse = new PulseStore();
