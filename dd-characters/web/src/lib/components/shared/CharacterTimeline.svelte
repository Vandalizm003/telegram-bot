<script lang="ts">
  import { formatLastPlayed, formatPlaytime } from '$lib/utils/format';

  interface Props {
    lastPlayed?: string | number;
    playtimeHours?: number;
  }

  let { lastPlayed, playtimeHours }: Props = $props();
</script>

<div class="grid grid-cols-2 gap-4 border-t border-white/10 pt-4">
  <div>
    <p class="text-[11px] tracking-[0.2em] text-white/40 uppercase">Last played</p>
    <p class="mt-1 text-sm text-white/85">{formatLastPlayed(lastPlayed)}</p>
  </div>
  <div>
    <p class="text-[11px] tracking-[0.2em] text-white/40 uppercase">Total hours</p>
    <p class="mt-1 text-sm text-white/85">{formatPlaytime(playtimeHours)}</p>
  </div>
</div>
