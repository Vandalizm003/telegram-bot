export function formatCurrency(value: number): string {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    maximumFractionDigits: 0,
  }).format(value);
}

export function formatDate(value: string): string {
  const date = new Date(value);

  if (Number.isNaN(date.getTime())) {
    return value;
  }

  return date.toLocaleDateString('en-GB').replace(/\//g, '-');
}

export function formatLastPlayed(value?: string | number): string {
  if (value === undefined || value === null || value === '') return '—';

  const date =
    typeof value === 'number' ? new Date(value * 1000) : new Date(value);

  if (Number.isNaN(date.getTime())) return '—';

  const now = new Date();
  const diffMs = now.getTime() - date.getTime();
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));

  if (diffDays <= 0) return 'Today';
  if (diffDays === 1) return 'Yesterday';
  if (diffDays < 7) return `${diffDays} days ago`;

  return formatDate(typeof value === 'number' ? new Date(value * 1000).toISOString() : value);
}

export function formatPlaytime(hours?: number): string {
  if (hours === undefined || hours <= 0) return '—';
  if (hours < 1) return '< 1 hr';
  if (hours === 1) return '1 hr';

  return `${Math.round(hours)} hrs`;
}

export function formatPulseTime(value: string): string {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return '—';

  const diffMs = Date.now() - date.getTime();
  const diffMins = Math.floor(diffMs / (1000 * 60));

  if (diffMins < 1) return 'Just now';
  if (diffMins < 60) return `${diffMins}m ago`;

  const diffHours = Math.floor(diffMins / 60);
  if (diffHours < 24) return `${diffHours}h ago`;

  return formatDate(value);
}
