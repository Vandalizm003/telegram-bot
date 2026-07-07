export const RESOURCE_NAME = 'dd-characters';

export const BACKSTORY_MAX_LENGTH = 300;

export const MIN_NAME_LENGTH = 2;
export const MAX_NAME_LENGTH = 16;

/** Must match data/server.lua validation. */
export const MIN_BIRTH_YEAR = 1940;
export const MAX_BIRTH_YEAR = 2006;
export const MIN_HEIGHT_CM = 140;
export const MAX_HEIGHT_CM = 220;

/** Minimum black-screen brand time before reveal can start. */
export const INTRO_MIN_MS = 1800;
/** Fade-out duration for intro overlay + UI fade-in (keep in sync with CSS). */
export const INTRO_EXIT_MS = 900;
/** Max wait for preview camera before revealing anyway. */
export const INTRO_PREVIEW_TIMEOUT_MS = 8000;

export const GENDERS = [
  { id: 0, label: 'Male' },
  { id: 1, label: 'Female' },
] as const;

export const NATIONALITIES = [
  'American',
  'British',
  'Canadian',
  'French',
  'German',
  'Italian',
  'Spanish',
  'Mexican',
  'Brazilian',
  'Japanese',
  'Chinese',
  'Korean',
  'Australian',
  'Angolan',
  'South African',
  'Other',
] as const;
