# **BeeFit: Documento de Elicitação e Estratégia de Requisitos**

| Projeto | BeeFit - Gerenciador Inteligente de Treinos de Musculação |
| :--- | :--- |
| **Equipe** | Victor Itiro Ogitsu, Nicholas Pucharelli Fontanini, Jociclelio Castro Macedo Junior, Iran Seixas Lopes Neto, Rafael Attilio Agricola    |
| **Data** | 13/10/2025 |

## 1. Introdução

Este documento detalha o processo de elicitação de requisitos para o aplicativo BeeFit. Utilizamos uma abordagem combinada de **Benchmarking** para analisar o cenário de mercado e **Brainstorming** para gerar ideias inovadoras. O objetivo é definir um conjunto claro de funcionalidades para o nosso *Minimum Viable Product* (MVP), garantindo que o BeeFit entregue valor real e se diferencie da concorrência desde o seu lançamento.

---

## 2. Benchmarking (Análise Competitiva)

### 2.1. Metodologia

Analisamos 3 (três) aplicativos concorrentes com base em suas funcionalidades, modelo de negócio, experiência do usuário (UI/UX) e feedback público (avaliações na App Store e Play Store). O objetivo foi identificar padrões de mercado, funcionalidades essenciais (*table stakes*) e oportunidades de diferenciação.

**Aplicativos Analisados:**
*   **Strong:** Famoso pela simplicidade e foco no registro de dados.
*   **Jefit:** Conhecido pela vasta biblioteca de exercícios e planos de treino.
*   **Hevy:** Destaque para o aspecto social e design moderno.

### 2.2. Tabela Comparativa de Funcionalidades

| Funcionalidade | Strong | Jefit | Hevy | Implicação Estratégica para o BeeFit |
| :--- | :---: | :---: | :---: | :--- |
| **Criação de Treino Livre e Flexível** | ✅ | ✅ | ✅ | **Não negociável.** Nossa interface para isso deve ser a mais rápida e intuitiva do mercado. |
| **Biblioteca de Exercícios com Mídia** | ✅ | ✅ | ✅ | Essencial para guiar o usuário. Podemos começar com GIFs (mais leves) e evoluir para vídeos. |
| **Logging Avançado (Notas, Séries, Carga)** | ✅ | ✅ | ✅ | **Obrigatório.** É o *core loop* do app. Deve ser extremamente fácil registrar um set. |
| **Cronômetro de Descanso Automático** | ✅ | ✅ | ✅ | Implementar de forma inteligente e não intrusiva. Customização é um diferencial. |
| **Gráficos e Relatórios de Progresso** | ✅ | ✅ | ✅ | Focar em visualizações que importam: volume total, 1RM estimado, recordes pessoais. |
| **Componente Social (Feed, Amigos)** | ❌ | ✅ | ✅ | **Oportunidade.** Podemos adiar isso para focar 100% na experiência individual, que é uma dor em apps com excesso de features sociais. |
| **Backup em Nuvem** | Apenas Pago | ✅ | ✅ | Oferecer backup gratuito é um diferencial poderoso para aquisição e retenção de usuários. |
| **Modelo de Monetização** | Assinatura | Freemium | Freemium | Adotar um modelo Freemium justo, onde o *core* do app é gratuito e funcionalidades avançadas são pagas. |

### 2.3. Principais Insights da Análise

*   **Ponto Forte dos Concorrentes:** Todos são excelentes em registrar dados. A interface limpa do Strong e o aspecto social do Hevy são os maiores destaques.
*   **Ponto Fraco (Dor do Usuário):** As principais queixas são sobre interfaces que se tornaram muito complexas com o tempo, paywalls agressivos que bloqueiam funções básicas e a falta de flexibilidade na edição de treinos já iniciados.
*   **Nossa Oportunidade:** O BeeFit pode se destacar ao focar na **velocidade e simplicidade da experiência de treino**. Menos cliques para registrar, edição fácil e um design limpo, sem poluição visual.

---

## 3. Sessão de Brainstorming

### 3.1. Metodologia

Realizamos uma sessão de ideação em equipe utilizando a ferramenta **FigJam**. Durante 60 minutos, geramos ideias livremente (`fase de divergência`) e depois agrupamos em temas e votamos nas prioridades (`fase de convergência`) para definir o escopo do nosso MVP.

### 3.2. Evidências

**Quadro de Brainstorming no FigJam:**

A imagem abaixo é um snapshot do nosso processo, mostrando as ideias agrupadas e as mais votadas.

![Quadro de Brainstorming](prints/figjam_beefit.png)


### 3.3. Ideias Prioritárias e Temas Emergentes

*   **Tema 1: O Essencial Bem Feito**
    *   **Criador de Treino "Arrasta e Solta":** Facilitar a montagem e reordenação de exercícios.
    *   **"Modo Foco" durante o treino:** Interface minimizada com apenas o exercício atual, timer e campos de registro.
    *   **Histórico Inteligente:** Ao selecionar um exercício, mostrar a última carga e repetições realizadas para facilitar a progressão de carga.

*   **Tema 2: Pequenos Diferenciais ("Delighters")**
    *   **Sugestão de Placas/Anilhas:** Com base no peso que o usuário quer levantar, o app sugere a combinação de anilhas.
    *   **Celebração de Recordes Pessoais (PRs):** Pequenas animações ou feedbacks visuais ao bater um recorde.
    *   **Modo Escuro (Dark Mode) nativo.**

---

## 4. Conclusão e Definição do MVP

Com base na análise de mercado e em nossas ideias, definimos que o MVP do BeeFit se concentrará em ser a ferramenta **mais rápida e agradável para criar, executar e acompanhar um treino de musculação.**

**Funcionalidades Prioritárias para o MVP:**

1.  **Gerenciamento de Rotinas:** Permitir que o usuário crie, edite e organize seus treinos (ex: Treino A, B, C).
2.  **Execução de Treino:** Uma interface limpa para seguir o treino, registrar séries/cargas/repetições e usar um cronômetro de descanso.
3.  **Histórico e Progresso Básico:** O usuário deve ser capaz de ver seu histórico por exercício para acompanhar sua evolução.

Funcionalidades como componentes sociais, relatórios avançados e planos de treino pré-definidos serão consideradas para versões futuras, permitindo-nos lançar um produto enxuto, focado e de alta qualidade.

### 4.1. Próximos Passos

Os insights e as funcionalidades prioritárias descritas neste documento serão agora convertidos em **Épicos** e **Histórias de Usuário** no GitHub Issues do projeto, com a devida priorização no nosso quadro de projeto.