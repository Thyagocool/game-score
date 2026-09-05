# ⚙️ Execute - Controle do Desenvolvimento

## 🛠️ Tecnologias

| Tecnologia | Versão | Uso |
|------------|--------|-----|
| Flutter | 3.47.2 | Framework mobile híbrido |
| Dart | 3.13.2 | Linguagem de programação |
| VS Code | Latest | Editor de código |

---

## 📜 Regras de Execução (Obrigatórias)

### 1. Controle de Versão
- ❌ **NUNCA** fazer commit sem solicitação explícita do usuário
- ❌ **NUNCA** abrir PR sem solicitação do usuário
- ❌ **NUNCA** criar branch sem autorização do usuário
- ❌ **NUNCA** fazer push sem solicitação do usuário

### 2. Instalações e Configurações
- ❌ **NUNCA** instalar dependências sem autorização do usuário
- ❌ **NUNCA** alterar configurações do projeto sem autorização
- ❌ **NUNCA** modificar arquivos de configuração do Flutter/SDK

### 3. Fluxo de Execução
- ⏳ **SOMENTE** executar a próxima etapa quando o usuário solicitar
- ✅ **DEPOIS** de cada execução, atualizar `plano.md`
- 📝 **DEPOIS** de cada execução, atualizar `checkpoint.md`
- 🔄 **AGUARDAR** validação do usuário antes de avançar

---

## 📂 Estrutura de Arquivos de Controle

```
game-score/
├── plano.md          # Roadmap do projeto (checklist)
├── execute.md        # Este arquivo (regras de controle)
├── checkpoint.md     # Log detalhado de cada execução
└── lib/              # Código Flutter
```

---

## 🔄 Fluxo de Trabalho

```
┌─────────────────────────────────────────────────────────┐
│  1. Usuário solicita execução da próxima etapa          │
│  2. Agente executa a tarefa                             │
│  3. Agente atualiza plano.md (marca checkbox)           │
│  4. Agente atualiza checkpoint.md (detalhes)            │
│  5. Agente informa ao usuário o que foi feito           │
│  6. Usuário valida e solicita próxima etapa             │
└─────────────────────────────────────────────────────────┘
```

---

## 📋 Status de Execução

| Fase | Etapa | Status | Última Atualização |
|------|-------|--------|-------------------|
| 1 | Configurar ambiente | ✅ Concluída | 05/09/2026 |
| 2 | Layout da tela | ✅ Concluída | 05/09/2026 |
| 3 | Lógica da roleta | ⏳ Aguardando | - |
| 4 | Sistema de pontuação | ⏳ Aguardando | - |
| 5 | Extras | ⏳ Aguardando | - |

---

**⚠️ IMPORTANTE:** Este arquivo é o norte do desenvolvimento. Qualquer desvio das regras aqui estabelecidas deve ser autorizado previamente pelo usuário.
