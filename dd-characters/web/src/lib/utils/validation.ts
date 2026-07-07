import { MAX_BIRTH_YEAR, MAX_HEIGHT_CM, MAX_NAME_LENGTH, MIN_BIRTH_YEAR, MIN_HEIGHT_CM, MIN_NAME_LENGTH } from '$lib/constants';

const NAME_PATTERN = /^[a-zA-Z\s\-']+$/;

export function isValidName(value: string): boolean {
  const trimmed = value.trim();
  return (
    trimmed.length >= MIN_NAME_LENGTH &&
    trimmed.length <= MAX_NAME_LENGTH &&
    NAME_PATTERN.test(trimmed)
  );
}

export function sanitizeNameInput(value: string): string {
  return value.replace(/[^a-zA-Z\s\-']/g, '').slice(0, MAX_NAME_LENGTH);
}

export function sanitizeHeightInput(value: string): string {
  const digits = value.replace(/\D/g, '').slice(0, 3);
  if (digits === '') return '';

  const num = Number(digits);
  if (num > MAX_HEIGHT_CM) {
    return String(MAX_HEIGHT_CM);
  }

  return digits;
}

export function isValidBirthdate(value: string): boolean {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) {
    return false;
  }

  const year = Number(value.slice(0, 4));
  const month = Number(value.slice(5, 7));
  const day = Number(value.slice(8, 10));

  if (
    !Number.isInteger(year) ||
    !Number.isInteger(month) ||
    !Number.isInteger(day) ||
    year < MIN_BIRTH_YEAR ||
    year > MAX_BIRTH_YEAR ||
    month < 1 ||
    month > 12 ||
    day < 1 ||
    day > 31
  ) {
    return false;
  }

  const date = new Date(year, month - 1, day);

  return (
    date.getFullYear() === year &&
    date.getMonth() === month - 1 &&
    date.getDate() === day
  );
}

export function birthdateInputBounds(): { min: string; max: string } {
  return {
    min: `${MIN_BIRTH_YEAR}-01-01`,
    max: `${MAX_BIRTH_YEAR}-12-31`,
  };
}

export function isValidHeight(value: string): boolean {
  const height = Number(value.trim());
  return (
    value.trim() !== '' &&
    Number.isFinite(height) &&
    Number.isInteger(height) &&
    height >= MIN_HEIGHT_CM &&
    height <= MAX_HEIGHT_CM
  );
}
