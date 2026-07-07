<script lang="ts">
  import { app } from '$lib/stores/app.svelte';
  import ActionMenuButton from '$lib/components/shared/ActionMenuButton.svelte';
  import { BookOpen, LogOut, Play, Radio } from 'lucide-svelte';

  interface MenuItem {
    id: string;
    label: string;
    sub: string;
    icon: typeof Play;
    action: () => void;
    visible: boolean;
  }

  const items = $derived<MenuItem[]>([
    {
      id: 'play',
      label: 'Play Game',
      sub: 'Start your journey',
      icon: Play,
      action: () => app.playGame(),
      visible: Boolean(app.selectedCharacter),
    },
    {
      id: 'codex',
      label: 'Codex',
      sub: 'Lore, rules & onboarding',
      icon: BookOpen,
      action: () => app.openCodex(),
      visible: app.config.enableCodex,
    },
    {
      id: 'pulse',
      label: 'Pulse',
      sub: 'Live feed & announcements',
      icon: Radio,
      action: () => app.openPulse(),
      visible: app.config.enablePulse,
    },
    {
      id: 'exit',
      label: 'Exit Game',
      sub: 'Goodbye!',
      icon: LogOut,
      action: () => app.exitGame(),
      visible: true,
    },
  ]);

  const visibleItems = $derived(items.filter((item) => item.visible));
</script>

<div class="w-[220px] shrink-0 border border-white/12 bg-black/55 px-2 py-1">
  <nav class="flex flex-col">
    {#each visibleItems as item, index (item.id)}
      <ActionMenuButton
        label={item.label}
        sub={item.sub}
        icon={item.icon}
        showDivider={index < visibleItems.length - 1}
        onclick={item.action}
      />
    {/each}
  </nav>
</div>
