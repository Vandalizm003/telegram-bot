import { mockCodexSections } from '$lib/mocks/codex';
import { fetchNui } from '$lib/nui/fetch';
import type { CodexCategory, CodexSection } from '$lib/types/codex';

class CodexStore {
  sections = $state<CodexSection[]>([]);
  selectedId = $state<string | null>(null);
  loading = $state(false);

  get selectedSection(): CodexSection | null {
    return this.sections.find((s) => s.id === this.selectedId) ?? null;
  }

  get categories(): { id: CodexCategory; label: string }[] {
    return [
      { id: 'onboarding', label: 'Start' },
      { id: 'rules', label: 'Rules' },
      { id: 'lore', label: 'Lore' },
    ];
  }

  sectionsForCategory(category: CodexCategory): CodexSection[] {
    return this.sections.filter((s) => s.category === category);
  }

  async load(): Promise<void> {
    this.loading = true;

    try {
      const payload = await fetchNui<{ sections: CodexSection[] }>('getCodex');
      this.sections = payload.sections?.length ? payload.sections : mockCodexSections;
      this.selectedId = this.sections[0]?.id ?? null;
    } catch {
      this.sections = mockCodexSections;
      this.selectedId = this.sections[0]?.id ?? null;
    } finally {
      this.loading = false;
    }
  }

  select(id: string): void {
    this.selectedId = id;
  }

  reset(): void {
    this.sections = [];
    this.selectedId = null;
    this.loading = false;
  }
}

export const codex = new CodexStore();
