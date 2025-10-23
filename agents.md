# Diretrizes Flutter

## Composição de Widgets
- Prefira composição sobre herança
- Combine widgets simples para funcionalidades complexas
- Use widgets existentes como blocos de construção
- Evite widgets monolíticos

## Extração de Widgets
- Extraia quando widget > 50 linhas
- Extraia quando há lógica repetitiva
- Extraia quando código pode ser reutilizado
- Extraia quando responsabilidade pode ser isolada

## Regras de Implementação
- Single Responsibility por widget
- Widgets reutilizáveis
- Código testável
- Fácil manutenção

## Checklist para Novos Widgets
- [ ] Uma única responsabilidade?
- [ ] Reutilizável em outros contextos?
- [ ] Composto por widgets menores?
- [ ] Menos de 50 linhas?
- [ ] Parâmetros bem definidos?
- [ ] Segue padrão de nomenclatura?

## Ferramentas
- Extract Widget: Refactor → Extract Widget
- Extract Method: Para lógica complexa no build()

## Benefícios
- Performance otimizada
- Debug mais fácil
- Código legível
- Escalabilidade