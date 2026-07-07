import type { PulseItem } from '$lib/types/pulse';

export const mockPulseStation = {
  station: 'DD Pulse',
  frequency: '104.2 FM',
  tagline: 'Your signal into the city',
};

export const mockPulseItems: PulseItem[] = [
  {
    id: '1',
    type: 'alert',
    headline: 'Downtown activity',
    body: 'Reports of heavy police presence near Legion Square. Avoid the area if possible — detours recommended along Integrity Way.',
    timestamp: '2026-07-03T17:42:00.000Z',
    source: 'City Dispatch',
  },
  {
    id: '2',
    type: 'event',
    headline: 'Weekend car meet',
    body: 'Unofficial meetup at Alta Street parking lot, Saturday 9 PM. All builds welcome. Keep it clean — locals are watching.',
    timestamp: '2026-07-03T16:10:00.000Z',
    source: 'Street Feed',
  },
  {
    id: '3',
    type: 'info',
    headline: 'EMS hiring open',
    body: 'Pillbox Hospital is accepting new applications. Training sessions run every evening. Check in at the front desk for details.',
    timestamp: '2026-07-03T14:30:00.000Z',
    source: 'Public Notice',
  },
  {
    id: '4',
    type: 'info',
    headline: 'Weather advisory',
    body: 'Coastal fog expected tonight across Paleto and Sandy Shores. Drive with caution on Route 68 after dark.',
    timestamp: '2026-07-03T12:00:00.000Z',
    source: 'Traffic Desk',
  },
  {
    id: '5',
    type: 'event',
    headline: 'Live DJ — Tequi-la-la',
    body: 'Friday night set starts at 11 PM. Cover charge waived for first arrivals. Dress code enforced.',
    timestamp: '2026-07-03T09:15:00.000Z',
    source: 'Nightlife Wire',
  },
];
