# Diretrizes de Desenvolvimento Flutter

## Composição de Widgets e Extração de Widgets

### Princípios Fundamentais

**SEMPRE** aplicar os seguintes princípios ao criar novos widgets:

#### 1. Composição de Widgets
- Prefira **composição** sobre herança
- Combine widgets simples para criar funcionalidades complexas
- Use widgets existentes como blocos de construção
- Evite criar widgets monolíticos

#### 2. Extração de Widgets
- **Extraia widgets** quando:
  - Um widget tem mais de 50 linhas
  - Há lógica repetitiva
  - O código pode ser reutilizado
  - A responsabilidade pode ser isolada

### Padrões Obrigatórios

#### Widget Extraction Pattern
```dart
// ❌ Evitar - Widget monolítico
class BadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 100+ linhas de código aqui
      ],
    );
  }
}

// ✅ Preferir - Widgets extraídos
class GoodWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderSection(),
        ContentSection(),
        FooterSection(),
      ],
    );
  }
}
```

#### Composition Pattern
```dart
// ✅ Composição de widgets simples
class ItemCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ItemCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        onTap: onTap,
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}
```

### Regras de Implementação

1. **Single Responsibility**: Cada widget deve ter uma única responsabilidade
2. **Reusabilidade**: Widgets devem ser reutilizáveis em diferentes contextos
3. **Testabilidade**: Widgets extraídos são mais fáceis de testar
4. **Manutenibilidade**: Código organizado em widgets pequenos é mais fácil de manter

### Exemplos do Projeto

#### Extração Correta (Baseado no código atual)
```dart
// Widget extraído para responsabilidade específica
class ItemsListWidget extends StatelessWidget {
  final List<ShoppingItemEntity> items;
  final Future<void> Function(ShoppingItemEntity) onToggleCompletion;
  
  const ItemsListWidget({
    super.key,
    required this.items,
    required this.onToggleCompletion,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ChecklistItemWidget(
          item: items[index],
          onChanged: (value) => onToggleCompletion(items[index]),
        );
      },
    );
  }
}
```

#### Composição Correta
```dart
// Composição de múltiplos widgets extraídos
class ChecklistSections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeaderWidget(viewMode: ViewMode.shopping),
        Divider(),
        ItemsListWidget(items: notCompletedItems),
        SectionHeaderWidget(viewMode: ViewMode.purchased),
        ItemsListWidget(items: completedItems),
      ],
    );
  }
}
```

### Checklist para Novos Widgets

Antes de criar um widget, verifique:

- [ ] O widget tem uma única responsabilidade?
- [ ] Pode ser reutilizado em outros contextos?
- [ ] Está composto por widgets menores quando possível?
- [ ] Tem menos de 50 linhas de código?
- [ ] Os parâmetros são bem definidos e tipados?
- [ ] Segue o padrão de nomenclatura do projeto?

### Ferramentas de Refatoração

Use as ferramentas do IDE para extrair widgets:
- **Extract Widget**: Selecione código → Refactor → Extract Widget
- **Extract Method**: Para lógica complexa dentro do build()

### Benefícios

- **Performance**: Widgets menores são mais eficientes para rebuild
- **Debugging**: Mais fácil identificar problemas em widgets específicos
- **Colaboração**: Código mais legível para a equipe
- **Escalabilidade**: Facilita adição de novas funcionalidades