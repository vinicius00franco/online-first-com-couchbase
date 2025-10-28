# Planejamento Ágil - Isolamento de Dados por Usuário

## Visão Geral
Implementar isolamento obrigatório de dados de tarefas por usuário registrado, com UUIDs obrigatórios para inputs/retornos e redirecionamento automático para login quando não autenticado.

## Telas e Funcionalidades

### 1. Tela de Login
**Objetivo**: Autenticar usuário e permitir acesso ao sistema.

**Histórias de Usuário**:
- Como usuário, quero fazer login com email e senha para acessar minhas tarefas
- Como usuário, quero ver mensagens de erro claras se credenciais forem inválidas
- Como usuário, quero opção de criar nova conta se não tiver cadastro

**Critérios de Aceitação**:
- Formulário com campos email e senha obrigatórios
- Validação de email válido e senha ≥6 caracteres
- Botão "Entrar" desabilitado até formulário válido
- Loading state durante autenticação
- Mensagens de erro via SnackBar
- Navegação para registro opcional

**Tarefas Técnicas**:
- Usar AuthCubit existente para login
- Implementar validação de formulário
- Tratar estados de loading e erro
- Design system consistente (AppColors, AppTextStyles)

### 2. Tela de Checklist
**Objetivo**: Gerenciar tarefas pessoais do usuário logado.

**Histórias de Usuário**:
- Como usuário logado, quero ver apenas minhas tarefas
- Como usuário logado, quero adicionar novas tarefas com título e preço
- Como usuário logado, quero marcar tarefas como concluídas
- Como usuário logado, quero editar título e preço das tarefas
- Como usuário logado, quero excluir tarefas
- Como usuário não logado, quero ser redirecionado para login

**Critérios de Aceitação**:
- Lista filtrada por userId do usuário logado
- Formulário de adição com título obrigatório e preço opcional
- Cada tarefa tem UUID único gerado automaticamente
- Operações CRUD usam UUID para identificação
- Estados de loading para operações assíncronas
- Confirmação antes de excluir
- Navegação para perfil do usuário

**Tarefas Técnicas**:
- Atualizar FetchChecklistCubit para aceitar userId
- Modificar AddChecklistCubit para gerar UUID e associar userId
- Atualizar UpdateChecklistCubit e DeleteChecklistCubit para usar UUID
- ChecklistRepository filtra por userId e usa UUID como chave
- ShoppingItemEntity com userId e uuid obrigatórios
- UuidHelper para geração de UUIDs v4

### 3. Tela de Perfil
**Objetivo**: Gerenciar dados pessoais e fazer logout.

**Histórias de Usuário**:
- Como usuário logado, quero ver e editar meus dados pessoais
- Como usuário logado, quero alterar senha se necessário
- Como usuário logado, quero fazer logout do sistema
- Como usuário logado, quero confirmação antes de logout

**Critérios de Aceitação**:
- Formulário pré-preenchido com dados atuais
- Campos nome, email obrigatórios; senha opcional
- Validação de email e senha ≥6 caracteres
- Confirmação de senha quando alterando
- Botão "Salvar" para atualizar dados
- Botão "Sair" para logout
- Loading states para operações
- Mensagens de sucesso/erro via SnackBar

**Tarefas Técnicas**:
- Usar AuthCubit para updateProfile e logout
- Formulário com validação complexa (confirmação de senha)
- Estados de loading e erro do AuthCubit
- Design system consistente

## Arquitetura e Padrões

### Camadas
- **UI**: Widgets com BLoC para estado
- **Apresentação**: Cubits gerenciando estado e lógica
- **Dados**: Repositories abstraindo acesso ao Couchbase
- **Domínio**: Entities com validação e regras

### Padrões de Estado
- BLoC/Cubit para gerenciamento de estado
- Estados imutáveis com copyWith
- Listener para efeitos colaterais (navegação, SnackBar)

### Segurança e Isolamento
- Dados filtrados por userId em tempo real
- UUIDs únicos para evitar conflitos
- Autenticação obrigatória via AuthGate
- Logout limpa estado do usuário

### Testes
- TDD para novas funcionalidades
- Testes unitários para lógica de negócio
- Testes de widget para UI crítica
- Mocks para dependências externas

## Critérios de Pronto
- [x] Entidade atualizada com userId/uuid obrigatórios
- [x] UuidHelper implementado e testado
- [x] Repository filtra por userId e usa uuid
- [x] Cubits atualizados para isolamento
- [x] AuthGate redireciona não autenticados
- [x] LoginPage usa AuthCubit existente
- [x] ProfilePage permite logout
- [x] Documentação de planejamento criada
- [ ] Testes automatizados passando
- [ ] Funcionalidade testada manualmente
- [ ] Code review aprovado