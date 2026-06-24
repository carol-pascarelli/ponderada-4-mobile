# Reminders

## Sobre o Projeto

O Reminders é um aplicativo mobile desenvolvido em Flutter com o objetivo de ajudar estudantes a organizarem melhor suas atividades, estudos e compromissos diários.

A ideia surgiu a partir da dificuldade que muitos estudantes possuem para conciliar tarefas acadêmicas, prazos de entrega, provas e momentos de estudo. O aplicativo busca centralizar essas informações em um único lugar, oferecendo ferramentas para planejamento, organização e acompanhamento da produtividade.

Além do gerenciamento de tarefas, o aplicativo também conta com sessões de foco utilizando a técnica Pomodoro e geração de planos de estudo utilizando Inteligência Artificial.


[Vídeo de demonstração do app](https://youtu.be/yR9HC6Jut3g)
---

# Problema Identificado

Muitos estudantes utilizam diferentes ferramentas para organizar sua rotina, como aplicativos de notas, agenda do celular e lembretes. Isso faz com que informações importantes fiquem espalhadas, dificultando o planejamento e o acompanhamento das atividades.

O Reminders foi desenvolvido para concentrar essas funcionalidades em uma única aplicação, permitindo uma experiência mais simples e organizada.

---

# Objetivos

* Organizar tarefas e compromissos.
* Auxiliar no planejamento dos estudos.
* Melhorar a produtividade utilizando sessões Pomodoro.
* Utilizar Inteligência Artificial para gerar cronogramas de estudo.
* Aplicar conceitos de desenvolvimento mobile, backend, banco de dados e integração com APIs.

---

# Tecnologias Utilizadas

## Frontend

* Flutter
* Material Design 3

## Backend

* Firebase

## Banco de Dados

* Cloud Firestore

## Autenticação

* Firebase Authentication

## Gerenciamento de Estado

* Provider

## API Externa

* Gemini API

## Notificações

* flutter_local_notifications

## Compartilhamento

* share_plus

## Hardware do Dispositivo

* GPS / Localização (geolocator)

---

# Arquitetura do Projeto

Durante o desenvolvimento foi utilizada uma arquitetura em camadas baseada em princípios de Clean Code.

A estrutura foi organizada da seguinte forma:

```text
UI
↓
Provider
↓
Repository
↓
Firebase / Services
```

Essa separação permite reduzir o acoplamento entre as partes da aplicação e facilita futuras manutenções.

---

# Funcionalidades

## Login

Permite que o usuário realize autenticação utilizando e-mail e senha através do Firebase Authentication.

### Objetivo

Garantir que cada usuário tenha acesso apenas às suas próprias informações.

---

## Cadastro

Permite criar uma nova conta.

Os dados do usuário são armazenados no Firebase Authentication e registrados no banco de dados.

### Objetivo

Possibilitar a criação e gerenciamento de usuários de forma segura.

---

## Dashboard

Tela principal do aplicativo.

Nela o usuário pode:

* Visualizar tarefas pendentes.
* Criar novas tarefas.
* Acessar o Pomodoro.
* Gerar planos de estudo.
* Consultar estatísticas.

### Objetivo

Centralizar todas as funcionalidades da aplicação.

---

## Gerenciamento de Tarefas

O aplicativo permite:

* Criar tarefas.
* Editar tarefas.
* Excluir tarefas.
* Marcar tarefas como concluídas.

Todas as informações são persistidas no Firestore.

### Objetivo

Auxiliar na organização da rotina acadêmica.

---

## Sessões Pomodoro

O usuário pode iniciar sessões de foco utilizando a técnica Pomodoro.

Ao finalizar uma sessão:

* O tempo é registrado.
* Uma notificação é enviada.
* Os dados são utilizados nas estatísticas do usuário.

### Objetivo

Estimular períodos de concentração e melhorar a produtividade.

---

## Planejamento com Inteligência Artificial

O usuário informa um objetivo de estudo, por exemplo:

> Tenho uma prova de Flutter em 5 dias.

A aplicação envia essa informação para a API Gemini, que gera automaticamente um plano de estudos.

### Objetivo

Auxiliar estudantes na organização do tempo e dos conteúdos.

---

## Estatísticas

A aplicação apresenta informações como:

* Quantidade de tarefas concluídas.
* Quantidade de tarefas pendentes.
* Número de sessões Pomodoro realizadas.
* Tempo total dedicado aos estudos.

### Objetivo

Permitir o acompanhamento da produtividade.

---

## Compartilhamento

O usuário pode compartilhar seus resultados utilizando os recursos nativos do Android.

Exemplo:

> Concluí 5 tarefas hoje e estudei por 2 horas.

### Objetivo

Estimular o acompanhamento e divulgação dos resultados obtidos.

---

## Localização (GPS)

Ao criar tarefas, o usuário pode associar sua localização.

### Objetivo

Demonstrar a utilização de recursos de hardware do dispositivo móvel e enriquecer os registros realizados pelo usuário.

---

## Notificações

A aplicação envia notificações para:

* Lembretes de tarefas.
* Finalização de sessões Pomodoro.

### Objetivo

Ajudar o usuário a manter sua rotina organizada.

---

# Estrutura das Telas

## Tela de Login

Permite que usuários já cadastrados realizem autenticação utilizando e-mail e senha.

## Tela de Cadastro

Permite a criação de novas contas utilizando Firebase Authentication.

## Dashboard

Tela principal da aplicação, exibindo tarefas e acessos rápidos para as funcionalidades.

## Tela de Criação de Tarefas

Permite registrar novas tarefas contendo título, descrição, data e horário.

## Tela de Detalhes da Tarefa

Permite editar, concluir ou excluir tarefas existentes.

## Tela Pomodoro

Permite iniciar sessões de foco com cronômetro baseado na técnica Pomodoro.

## Tela de Planejamento com IA

Permite gerar cronogramas de estudo utilizando a API Gemini.

## Tela de Estatísticas

Apresenta indicadores de produtividade e acompanhamento do usuário.

---

# Requisitos da Atividade Atendidos

| Requisito             | Implementação                                                    |
| --------------------- | ---------------------------------------------------------------- |
| Aplicação Mobile      | Flutter                                                          |
| Múltiplas Telas       | Login, Cadastro, Dashboard, Tarefas, Pomodoro, IA e Estatísticas |
| Backend               | Firebase                                                         |
| Banco de Dados        | Firestore                                                        |
| API Externa           | Gemini API                                                       |
| Notificações          | flutter_local_notifications                                      |
| Compartilhamento      | share_plus                                                       |
| Hardware              | GPS                                                              |
| Clean Code            | Arquitetura em camadas                                           |
| Navegação entre Telas | Implementada                                                     |
| Persistência de Dados | Firestore                                                        |

---

# Aprendizados

Durante o desenvolvimento deste projeto foi possível aplicar conceitos importantes de desenvolvimento mobile, incluindo:

* Criação de interfaces utilizando Flutter.
* Integração com Firebase Authentication.
* Utilização do Firestore para persistência de dados.
* Consumo de APIs externas.
* Gerenciamento de estado utilizando Provider.
* Implementação de notificações locais.
* Utilização de recursos nativos do dispositivo.
* Organização do código utilizando princípios de Clean Code.

O desenvolvimento do Reminders permitiu compreender melhor como aplicações mobile modernas são estruturadas e como diferentes tecnologias podem trabalhar em conjunto para resolver problemas reais do dia a dia.

---

# Considerações Finais

O Reminders foi desenvolvido com o objetivo de oferecer uma solução simples para organização acadêmica e produtividade.

A aplicação reúne gerenciamento de tarefas, técnicas de foco, Inteligência Artificial e recursos nativos do dispositivo em uma única plataforma, demonstrando a integração entre frontend, backend, banco de dados e serviços externos dentro de um contexto real de desenvolvimento mobile.
