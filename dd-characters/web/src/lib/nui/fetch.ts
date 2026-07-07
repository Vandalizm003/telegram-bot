import { RESOURCE_NAME } from '$lib/constants';
import {
  addMockCharacter,
  getMockCharacters,
  mockConfig,
  mockPlayerName,
  removeMockCharacter,
} from '$lib/mocks/data';
import { mockCodexSections } from '$lib/mocks/codex';
import { mockPulseItems, mockPulseStation } from '$lib/mocks/pulse';
import type { CreateCharacterPayload } from '$lib/types/character';
import { isEnvBrowser } from '$lib/utils/misc';

const delay = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

const getResourceName = (): string => {
  const getParentResourceName = (
    window as Window & { GetParentResourceName?: () => string }
  ).GetParentResourceName;

  return getParentResourceName?.() ?? RESOURCE_NAME;
};

async function mockFetch<T>(event: string, data?: unknown): Promise<T> {
  await delay(400);

  switch (event) {
    case 'getCharacters':
      return {
        characters: getMockCharacters(),
        config: mockConfig,
        playerName: mockPlayerName,
      } as T;

    case 'createCharacter':
      return addMockCharacter(data as CreateCharacterPayload) as T;

    case 'deleteCharacter': {
      removeMockCharacter((data as { id: number }).id);
      return { success: true } as T;
    }

    case 'getCodex':
      return { sections: mockCodexSections } as T;

    case 'getPulse':
      return {
        station: mockPulseStation.station,
        frequency: mockPulseStation.frequency,
        tagline: mockPulseStation.tagline,
        items: mockPulseItems,
      } as T;

    case 'playGame':
    case 'openCodex':
    case 'openPulse':
    case 'exitGame':
    case 'previewCharacter':
      return { success: true } as T;

    case 'ui:ready':
      return { brand: { name: 'DD Characters', logoUrl: false } } as T;

    default:
      console.warn(`[NUI Mock] Unhandled event: ${event}`, data);
      return { success: true } as T;
  }
}

export async function fetchNui<T>(
  event: string,
  data?: unknown,
): Promise<T> {
  if (isEnvBrowser()) {
    return mockFetch<T>(event, data);
  }

  const response = await fetch(`https://${getResourceName()}/${event}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data ?? {}),
  });

  if (!response.ok) {
    throw new Error(`NUI callback failed: ${event}`);
  }

  return (await response.json()) as T;
}
