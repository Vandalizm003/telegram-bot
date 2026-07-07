export type CodexCategory = 'lore' | 'rules' | 'onboarding';

export interface CodexSection {
  id: string;
  title: string;
  category: CodexCategory;
  content: string;
}
