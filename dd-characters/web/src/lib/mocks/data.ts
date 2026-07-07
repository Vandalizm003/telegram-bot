import type { AppConfig, Character, CreateCharacterPayload } from '$lib/types/character';

export const mockPlayerName = 'Player';

export const mockConfig: AppConfig = {
  maxCharacters: 5,
  enableCodex: true,
  enablePulse: true,
};

export const mockCharacters: Character[] = [
  {
    id: 1,
    citizenid: 'ABC12345',
    firstname: 'Kael',
    lastname: 'Thomas',
    birthdate: '1998-10-18',
    phone: '948-624-8989',
    gender: 0,
    nationality: 'American',
    height: 182,
    job: { name: 'ambulance', label: 'SA-EMS' },
    money: { cash: 2500, bank: 100000 },
    backstory:
      'A dedicated EMS worker who moved to the city chasing a fresh start after years on the coast.',
    zodiac: 'Libra',
    lastPlayed: '2026-07-01T21:15:00.000Z',
    playtimeHours: 142,
  },
  {
    id: 2,
    citizenid: 'DEF67890',
    firstname: 'Saleem',
    lastname: 'Osman',
    birthdate: '1995-03-22',
    phone: '555-0142',
    gender: 0,
    nationality: 'British',
    height: 178,
    job: { name: 'unemployed', label: 'Civilian' },
    money: { cash: 4200, bank: 18500 },
    backstory:
      'Quiet entrepreneur with a taste for fast cars and late-night city drives.',
    zodiac: 'Aries',
    lastPlayed: '2026-06-28T14:30:00.000Z',
    playtimeHours: 38,
  },
  {
    id: 3,
    citizenid: 'GHI11223',
    firstname: 'Alp',
    lastname: 'Revenge',
    birthdate: '1992-11-03',
    phone: '555-0199',
    gender: 0,
    nationality: 'Angolan',
    height: 187,
    job: { name: 'unemployed', label: 'Civilian' },
    money: { cash: 500, bank: 1200 },
    backstory:
      'Alp Revenge is a man of few words, shaped by hardship and driven by loyalty to those he trusts.',
    zodiac: 'Scorpio',
    lastPlayed: '2026-07-02T09:45:00.000Z',
    playtimeHours: 267,
  },
];

let mockCharacterStore = [...mockCharacters];
let nextCharacterId = 4;

export const getMockCharacters = (): Character[] => [...mockCharacterStore];

export const addMockCharacter = (payload: CreateCharacterPayload): Character => {
  const character: Character = {
    id: nextCharacterId++,
    citizenid: `MOCK${nextCharacterId}`,
    firstname: payload.firstname,
    lastname: payload.lastname,
    birthdate: payload.birthdate,
    phone: `555-${String(Math.floor(Math.random() * 9000) + 1000)}`,
    gender: payload.gender,
    nationality: payload.nationality,
    height: payload.height,
    backstory: payload.backstory,
    job: { name: 'unemployed', label: 'Civilian' },
    money: { cash: 500, bank: 5000 },
    zodiac: 'Unknown',
  };

  mockCharacterStore = [...mockCharacterStore, character];
  return character;
};

export const removeMockCharacter = (id: number): void => {
  mockCharacterStore = mockCharacterStore.filter((c) => c.id !== id);
};
