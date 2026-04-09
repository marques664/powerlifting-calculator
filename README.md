# PWL Calc - Calculadora de Anilhas para Powerlifting 🏋️

Um aplicativo Flutter desenvolvido para ajudar atletas de powerlifting a calcular rapidamente quais anilhas usar para atingir um peso específico de treino ou competição.

## 🎯 Funcionalidades

- **Cálculo Automático de Anilhas**: Insira o peso desejado e o app calcula exatamente quais anilhas você precisa usar em cada lado da barra
- **Visualização Gráfica**: Veja uma representação visual de como a barra fica montada com as anilhas
- **Múltiplas Formas de Entrada**:
  - Digite o peso desejado manualmente
  - Use um controle deslizante
  - Clique nos botões rápidos (20kg, 40kg, 60kg, 80kg, 100kg)
- **Cores Padrão de Powerlifting**: As anilhas são exibidas com as cores oficiais de competição
- **Compatível com Padrões Olímpicos**: Utiliza o conjunto padrão de anilhas: 25kg, 20kg, 15kg, 10kg, 5kg, 2.5kg, 2kg, 1.5kg, 1kg, 0.5kg

## 📋 Como Usar

### 1. Executar o Aplicativo

```bash
flutter run
```

### 2. Na Interface do App

1. **Inserir o Peso**: Digite o peso total desejado (incluindo a barra)
   - Exemplo: Para fazer 100kg, você colocaria 100
   - A barra padrão pesa 20kg, então o app divide o peso restante por 2 (um lado da barra)

2. **Visualizar a Barra**: O app mostra:
   - Uma representação gráfica de como a barra fica montada
   - Lista detalhada das anilhas necessárias por lado
   - O peso total por lado

3. **Usar Controles Rápidos**:
   - Clique nos botões de peso rápido (20kg, 40kg, etc.)
   - Digite manualmente para máxima precisão

## 🏋️ Exemplo de Uso

**Cenário**: Você quer fazer um agachamento a 120kg

1. Digite ou selecione 120kg
2. O app calcula:
   - Peso por lado: (120 - 20) ÷ 2 = 50kg
3. Mostra visualmente e em lista:
   - 2x Anilhas de 20kg (40kg)
   - 1x Anilha de 10kg (10kg)
   - **Total por lado: 50kg**

## 🎨 Cores das Anilhas (Padrão Olímpico)

| Peso | Cor |
|------|-----|
| 25kg | Vermelha |
| 20kg | Azul |
| 15kg | Amarela |
| 10kg | Verde |
| 5kg  | Branca |
| 2.5kg | Rosa/Vermelha claro |
| 2kg | Ciano |
| 1.5kg | Amarelo escuro |
| 1kg | Roxo |
| 0.5kg | Cinza escuro |

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── models/
│   └── plate.dart           # Modelo de dados para anilhas
├── logic/
│   └── plate_calculator.dart # Lógica de cálculo de anilhas
└── ui/
    ├── plate_widget.dart    # Widget principal
    ├── bar_visual.dart      # Visualização gráfica da barra
    └── input_weight.dart    # Widget de entrada de peso
```

## 🔧 Requisitos

- Flutter SDK 3.10.4+
- Dart 3.10.4+

## 📦 Dependências

O projeto utiliza apenas as dependências padrão do Flutter:
- `flutter`
- `cupertino_icons`

## ✅ Testes

Para executar a análise estática do código:

```bash
flutter analyze
```

## 🚀 Construir para Diferentes Plataformas

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

### Windows
```bash
flutter build windows --release
```

## 📝 Notas Técnicas

- O app assume uma barra padrão de 20kg
- Todas as contas são feitas para um lado da barra (o outro lado é idêntico)
- Há uma margem de erro de 0.01kg para cálculos em ponto flutuante

## 🤝 Contribuições

Sinta-se à vontade para sugerir melhorias ou reportar bugs!

---

**Desenvolvido para atletas que querem poupar tempo e evitar confusões na hora de montar a barra!** 💪
