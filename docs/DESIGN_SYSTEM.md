# Design system — resumo

Resumo curto com os tokens principais e um exemplo de uso. A versão completa e detalhada
do design system foi movida para o `AGENTS.md` (seção "Design System").

Principais tokens
- Cores de marca: `AppColors.primary`
- Neutros: `AppColors.grey100 / grey300 / grey600`
- Semânticas: `AppColors.success / info / warning / error`
- Espaçamento base: `AppSpacing.xs / sm / md / lg / xl`
- Texto: `AppTextStyles.h1..h3`, `bodyLarge`, `bodyMedium`
- Tokens de tema: `AppTheme.borderRadius`, `AppTheme.buttonHeight`, `AppTheme.iconSize`

Exemplo de uso rápido
```dart
Container(
  padding: AppSpacing.cardPadding,
  decoration: BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
  ),
  child: Text('Exemplo', style: AppTextStyles.bodyLarge),
)
```

Para ver o conjunto completo de tokens, guias de migração e exemplos, consulte `AGENTS.md` —
seção Design System.