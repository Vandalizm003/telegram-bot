import { INTRO_EXIT_MS, INTRO_MIN_MS, INTRO_PREVIEW_TIMEOUT_MS } from '$lib/constants';
import { fetchNui } from '$lib/nui/fetch';
import { isEnvBrowser } from '$lib/utils/misc';
import type {
  AppConfig,
  Character,
  CharacterSlot,
  CharactersPayload,
  CreateCharacterPayload,
} from '$lib/types/character';
import type { AppScreen } from '$lib/types/nui';
import { codex } from '$lib/stores/codex.svelte';
import { pulse } from '$lib/stores/pulse.svelte';

export type AppOverlay = 'codex' | 'pulse' | null;

class AppStore {
  visible = $state(isEnvBrowser());
  screen = $state<AppScreen>('selection');
  overlay = $state<AppOverlay>(null);
  introActive = $state(false);
  introRevealing = $state(false);
  loading = $state(false);
  loadingMessage = $state('');

  playerName = $state('Player');
  brandName = $state('DD Characters');
  brandLogoUrl = $state<string | null>(null);
  previewReady = $state(false);
  characters = $state<Character[]>([]);
  config = $state<AppConfig>({
    maxCharacters: 1,
    enableCodex: true,
    enablePulse: true,
  });
  selectedIndex = $state(0);

  get slots(): CharacterSlot[] {
    const max = this.config.maxCharacters;
    const slots: CharacterSlot[] = this.characters.map((character) => ({
      type: 'character',
      character,
    }));

    while (slots.length < max) {
      slots.push({ type: 'empty' });
    }

    return slots;
  }

  get selectedSlot(): CharacterSlot | null {
    return this.slots[this.selectedIndex] ?? null;
  }

  get selectedCharacter(): Character | null {
    const slot = this.selectedSlot;
    return slot?.type === 'character' ? (slot.character ?? null) : null;
  }

  get canCreateCharacter(): boolean {
    return this.characters.length < this.config.maxCharacters;
  }

  async bootstrap(): Promise<void> {
    await this.loadCharacters(true);

    if (this.slots.length > 0) {
      this.selectIndex(Math.min(this.selectedIndex, this.slots.length - 1));
    }
  }

  private delay(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  private waitForPreviewReady(timeoutMs: number): Promise<void> {
    if (this.previewReady) {
      return Promise.resolve();
    }

    return new Promise((resolve) => {
      const started = Date.now();

      const tick = () => {
        if (this.previewReady || Date.now() - started >= timeoutMs) {
          resolve();
          return;
        }

        requestAnimationFrame(tick);
      };

      tick();
    });
  }

  private async runIntroSequence(): Promise<void> {
    await Promise.all([
      this.delay(INTRO_MIN_MS),
      this.waitForPreviewReady(INTRO_PREVIEW_TIMEOUT_MS),
    ]);

    this.introRevealing = true;
    await this.delay(INTRO_EXIT_MS);
  }

  async beginIntro(): Promise<void> {
    this.previewReady = false;
    this.introActive = true;
    this.introRevealing = false;
    this.loading = false;
    this.loadingMessage = '';
    this.screen = 'selection';
    this.overlay = null;

    const introDone = this.runIntroSequence();
    await Promise.all([this.bootstrap(), introDone]);

    this.introActive = false;
    this.introRevealing = false;
  }

  setBrand(brand?: { name?: string; logoUrl?: string | false | null }): void {
    if (!brand) return;

    if (typeof brand.name === 'string' && brand.name.trim()) {
      this.brandName = brand.name.trim();
    }

    if (brand.logoUrl === false || brand.logoUrl === null || brand.logoUrl === '') {
      this.brandLogoUrl = null;
      return;
    }

    if (typeof brand.logoUrl === 'string' && brand.logoUrl.trim()) {
      this.brandLogoUrl = brand.logoUrl.trim();
    }
  }

  markPreviewReady(): void {
    this.previewReady = true;
  }

  async loadCharacters(silent = false): Promise<void> {
    if (!silent) {
      this.loading = true;
      this.loadingMessage = 'Loading characters...';
    }

    try {
      const payload = await fetchNui<CharactersPayload>('getCharacters');

      this.characters = payload.characters;
      this.config = payload.config;
      this.playerName = payload.playerName?.trim() || 'Player';
      this.selectedIndex = 0;
    } finally {
      if (!silent) {
        this.loading = false;
        this.loadingMessage = '';
      }
    }
  }

  selectIndex(index: number): void {
    if (index < 0 || index >= this.slots.length) return;
    this.selectedIndex = index;

    const character = this.slots[index]?.character;
    if (character) {
      void fetchNui('previewCharacter', { id: character.id });
    }
  }

  nextSlot(): void {
    this.selectIndex((this.selectedIndex + 1) % this.slots.length);
  }

  prevSlot(): void {
    this.selectIndex(
      (this.selectedIndex - 1 + this.slots.length) % this.slots.length,
    );
  }

  openRegistration(): void {
    if (!this.canCreateCharacter) return;
    this.screen = 'create';
  }

  goToSelection(): void {
    this.screen = 'selection';
  }

  async createCharacter(payload: CreateCharacterPayload): Promise<void> {
    this.loading = true;
    this.loadingMessage = 'Creating character...';

    try {
      const result = await fetchNui<{
        success: boolean;
        characterId?: number;
        isNew?: boolean;
      }>('createCharacter', payload);

      if (!result.success || !result.characterId) {
        return;
      }

      await this.loadCharacters();

      const index = this.characters.findIndex((c) => c.id === result.characterId);
      if (index >= 0) {
        this.selectedIndex = index;
      }
    } finally {
      this.loading = false;
      this.loadingMessage = '';
    }
  }

  async deleteSelectedCharacter(): Promise<void> {
    const character = this.selectedCharacter;
    if (!character) return;

    this.loading = true;
    this.loadingMessage = 'Deleting character...';

    try {
      await fetchNui('deleteCharacter', { id: character.id });
      await this.loadCharacters();

      if (this.selectedIndex >= this.slots.length) {
        this.selectedIndex = Math.max(0, this.slots.length - 1);
      }
    } finally {
      this.loading = false;
      this.loadingMessage = '';
    }
  }

  async playGame(): Promise<void> {
    const character = this.selectedCharacter;
    if (!character) return;

    this.loading = true;
    this.loadingMessage = 'Starting game...';

    try {
      await fetchNui('playGame', { id: character.id });
    } finally {
      this.loading = false;
      this.loadingMessage = '';
    }
  }

  async openCodex(): Promise<void> {
    this.overlay = 'codex';
    void fetchNui('openCodex');
    try {
      await codex.load();
    } catch {
      /* fallback content is applied inside codex.load */
    }
  }

  async openPulse(): Promise<void> {
    this.overlay = 'pulse';
    void fetchNui('openPulse');
    try {
      await pulse.load();
    } catch {
      /* fallback content is applied inside pulse.load */
    }
  }

  closeOverlay(): void {
    this.overlay = null;
    codex.reset();
    pulse.reset();
  }

  async exitGame(): Promise<void> {
    await fetchNui('exitGame');
  }

  setVisible(visible: boolean): void {
    this.visible = visible;

    if (visible && !isEnvBrowser() && !this.introActive && !this.introRevealing) {
      this.introActive = true;
    }
  }

  setLoading(loading: boolean, message = ''): void {
    this.loading = loading;
    this.loadingMessage = message;
  }
}

export const app = new AppStore();
