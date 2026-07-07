export interface CharacterJob {
  name: string;
  label: string;
}

export interface CharacterMoney {
  cash: number;
  bank: number;
}

export interface Character {
  id: number;
  citizenid: string;
  firstname: string;
  lastname: string;
  birthdate: string;
  phone: string;
  gender: number;
  nationality: string;
  height: number;
  job: CharacterJob;
  money: CharacterMoney;
  backstory?: string;
  zodiac?: string;
  /** Unix seconds or ISO timestamp from backend. */
  lastPlayed?: string | number;
  /** Total playtime in hours — read from qbx metadata.playtime (seconds) / 3600. */
  playtimeHours?: number;
}

export interface CharacterSlot {
  type: 'character' | 'empty';
  character?: Character;
}

export interface CreateCharacterPayload {
  firstname: string;
  lastname: string;
  birthdate: string;
  gender: number;
  nationality: string;
  height: number;
  backstory?: string;
}

export interface AppConfig {
  maxCharacters: number;
  enableCodex: boolean;
  enablePulse: boolean;
}

export interface CharactersPayload {
  characters: Character[];
  config: AppConfig;
  playerName: string;
}
