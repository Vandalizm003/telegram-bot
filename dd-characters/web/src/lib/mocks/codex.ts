import type { CodexSection } from '$lib/types/codex';

export const mockCodexSections: CodexSection[] = [
  {
    id: 'welcome',
    title: 'Welcome to the City',
    category: 'onboarding',
    content:
      'Before you step out, take a moment to learn how the city works. Respect other players, stay in character, and treat every encounter as part of your story. Your choices here shape the world around you.',
  },
  {
    id: 'first-steps',
    title: 'First Steps',
    category: 'onboarding',
    content:
      'Find work through city hall or local businesses. Keep your phone handy for contacts and messages. Visit the hospital if you need medical care. Most importantly — introduce yourself and build relationships.',
  },
  {
    id: 'server-rules',
    title: 'Server Rules',
    category: 'rules',
    content:
      'No RDM or VDM. Value your life at all times. No metagaming or powergaming. Respect staff decisions. Mic and audio rules apply in all scenarios. Breaking rules may result in warnings, kicks, or bans.',
  },
  {
    id: 'combat-rules',
    title: 'Combat & Scenes',
    category: 'rules',
    content:
      'Every hostile action needs buildup and reason. Give others a chance to respond. Combat logging is prohibited. If a scene goes wrong, clip it and report through the proper channels instead of arguing in-character.',
  },
  {
    id: 'city-lore',
    title: 'The City',
    category: 'lore',
    content:
      'A sprawling metropolis built on ambition and secrets. Old money in Rockford Hills, grit in the south, and whispers in every alley. Factions rise and fall. The newspapers only print half the truth.',
  },
  {
    id: 'underground',
    title: 'The Underground',
    category: 'lore',
    content:
      'Beneath the nightlife and neon, networks of crews, fixers, and informants keep the city moving. Nothing stays hidden forever — but some stories are only told after midnight.',
  },
];
