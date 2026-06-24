# Reminders

Aplicativo Flutter para organização de tarefas, sessões Pomodoro e planos de estudo com IA (Gemini).

## Requisitos atendidos

- Flutter + Material Design 3
- Firebase Authentication + Firestore
- Provider (gerenciamento de estado)
- Gemini API (API externa)
- Notificações locais (`flutter_local_notifications`)
- Compartilhamento (`share_plus`)
- GPS / localização (`geolocator`) — associar local às tarefas
- Arquitetura em camadas: UI → Provider → Repository → Firebase/Services

## Configuração

### 1. Firebase

1. Crie um projeto em [Firebase Console](https://console.firebase.google.com/)
2. Ative **Authentication** (E-mail/Senha)
3. Crie banco **Firestore**
4. Instale o FlutterFire CLI e configure:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

5. Publique as regras de `firestore.rules` no Firebase Console

### 2. Índices Firestore

Crie índices compostos se o Firebase solicitar:

- `tasks`: `userId` ASC + `dueDate` ASC
- `focus_sessions`: `userId` ASC + `createdAt` DESC

### 3. Gemini API

Obtenha uma chave em [Google AI Studio](https://aistudio.google.com/apikey) e execute:

```bash
flutter run --dart-define=GEMINI_API_KEY=sua_chave_aqui
```

### 4. Executar

```bash
flutter pub get
flutter run
```

## Estrutura

```
lib/
├── main.dart
├── firebase_options.dart
└── src/
    ├── app.dart
    ├── core/
    ├── models/
    ├── repositories/
    ├── providers/
    ├── services/
    ├── screens/
    └── widgets/
```

## Fluxo principal

1. Login / Cadastro (Firebase Auth)
2. Dashboard com tarefas pendentes
3. CRUD de tarefas com localização GPS opcional (Firestore + lembretes)
5. Pomodoro 25 min (salva sessão + notificação)
6. Plano de estudos (Gemini)
7. Estatísticas + compartilhamento
