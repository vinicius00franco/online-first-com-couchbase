# Arquitetura do Sistema - Checklist Flutter

## 🏗️ Visão Geral Arquitetural

**Padrão**: Clean Architecture + BLoC + Repository Pattern + Offline-First

### Características Principais
- **Offline-First**: Operações funcionam sem conexão
- **Sincronização Bidirecional**: Push & Pull automático
- **Estado Reativo**: BLoC pattern com Cubits especializados
- **Logging Distribuído**: Sistema de auditoria integrado

## 📁 Estrutura de Camadas

```
lib/app/
├── entities/          # Domain Models
├── repositories/      # Data Access Layer
├── services/         # External Services
├── logic/           # Business Logic (Cubits)
├── pages/           # Presentation Layer
├── widget/          # UI Components
├── theme/           # Design System
├── utils/           # Configuration & Utilities
└── helpers/         # Auxiliary Functions
```

## 🔄 Fluxo de Dados

```
UI Event → Cubit → Repository → CouchbaseService → Local DB
                                      ↓
                                 Sync Gateway ← Remote DB
```

### Camadas Específicas
1. **Presentation**: Pages/Widgets (UI)
2. **Business Logic**: Cubits (Estado)
3. **Data Access**: Repositories (Abstração)
4. **External Services**: CouchbaseService (Persistência)

## 📊 Gerenciamento de Estado

### Cubits Especializados
- `FetchChecklistCubit` - Buscar itens
- `AddChecklistCubit` - Adicionar itens  
- `UpdateChecklistCubit` - Atualizar itens
- `DeleteChecklistCubit` - Deletar itens

### Injeção de Dependência
```dart
MultiProvider(
  providers: [
    Provider(CouchbaseService),
    Provider(ChecklistRepository),
    BlocProvider(FetchChecklistCubit),
    // ... outros cubits
  ]
)
```

## 💾 Persistência & Sincronização

### Tecnologias
- **Local**: Couchbase Lite (ACID transactions)
- **Sync**: Sync Gateway (conflict resolution)
- **Remote**: Couchbase Server

### Características Offline-First
```dart
// Replicação bidirecional com resolução de conflitos
replicatorType: ReplicatorType.pushAndPull,
conflictResolver: ConflictResolver.from((conflict) {
  return conflict.remoteDocument ?? conflict.localDocument;
})
```

### Monitoramento de Conectividade
```dart
// Auto-start/stop baseado na conectividade
networkConnection = Connectivity().onConnectivityChanged.listen((events) {
  if (events.contains(ConnectivityResult.none)) {
    replicator?.stop(); // Modo offline
  } else {
    replicator?.start(); // Sincronização online
  }
});
```

## 🔧 Detalhes Técnicos Específicos

### 1. Controle de Concorrência
```dart
// Last-write-wins para todas as operações
ConcurrencyControl.lastWriteWins
```

### 2. Serialização Otimizada
```dart
// Timestamp cross-platform compatível
'createdAt': createdAt.millisecondsSinceEpoch,
// ID opcional (gerado pelo Couchbase)
String? id;
```

### 3. Configuração Flexível
```dart
// Parametrização via .env
static String scope = dotenv.env['SCOPE_NAME'] ?? '_default';
static String collection = dotenv.env['COLLECTION_NAME'] ?? 'checklist_items';
static String channel = dotenv.env['CHANNEL'] ?? 'checklist_items';
```

### 4. Queries Otimizadas
```dart
// SQL-like queries com metadados
'SELECT META().id, * FROM ${scope}.${collection}'
```

## 🎨 Design System

### Tokens Principais
- **Cores**: `AppColors` (brand, neutral, semantic, surface)
- **Espaçamento**: `AppSpacing` (xs, sm, md, lg, xl)
- **Tipografia**: `AppTextStyles` (h1-h3, body variants)
- **Tema**: `AppTheme` (borderRadius, buttonHeight, iconSize)

### Migração Evolutiva
- Tokens novos coexistem com legacy
- Compatibilidade mantida durante refatoração
- Tokens semânticos por contexto

## 🐳 Infraestrutura de Desenvolvimento

### Docker Compose
- **Couchbase Server** + **Sync Gateway**
- **Scripts de automação** para setup
- **Configuração de usuários** automatizada

### Scripts Utilitários
- `debug-docker.sh` - Status de containers
- `sg-ensure-user.sh` - Configuração de usuários
- `sg-inspect.sh` - Inspeção de estado

## 🔒 Segurança & Configuração

### Autenticação
```dart
BasicAuthenticator(username: userName, password: password)
```

### Isolamento por Canais
```dart
channels: [CouchbaseContants.channel] // Controle de acesso
```

### Configuração de Rede
```dart
// Cleartext apenas para desenvolvimento
android:usesCleartextTraffic="true"
```

## ⚡ Otimizações

### 1. Lazy Loading
```dart
// Criação sob demanda de collections
await database?.createCollection(collectionName, scope);
```

### 2. Lifecycle Management
```dart
// Cleanup automático de recursos
replicator?.close();
networkConnection?.cancel();
```

### 3. Callback de Sincronização
```dart
// Atualização automática da UI após sync
onSynced: () {
  context.read<FetchChecklistCubit>().fetchItems();
}
```

## 📱 Funcionalidades Implementadas

- ✅ **CRUD completo** offline-first
- 🔄 **Sincronização automática** bidirecional
- 🎨 **Design system** consistente
- 🌐 **Configuração flexível** via environment
- 🔧 **Scripts de desenvolvimento** automatizados

## 🎯 Benefícios Arquiteturais

### Escalabilidade
- Separação clara de responsabilidades
- Injeção de dependência estruturada
- Componentes reutilizáveis

### Manutenibilidade
- Configuração centralizada
- Design system evolutivo

### Robustez
- Operações offline garantidas
- Resolução automática de conflitos
- Transações ACID locais

---

Esta arquitetura representa um **sistema offline-first maduro** com sincronização bidirecional e design system evolutivo - características avançadas para aplicações móveis empresariais.