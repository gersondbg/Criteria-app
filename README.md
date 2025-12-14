
# CRITERIA – Aplicación Inteligente de Apoyo a la Toma de Decisiones

## Descripción General
CRITERIA es una aplicación móvil desarrollada en Flutter que asiste a los usuarios en la toma de decisiones complejas mediante un enfoque de evaluación multicriterio. La aplicación permite ingresar un problema por texto o voz, definir criterios con pesos, evaluar alternativas y obtener una recomendación automática sustentada, incluyendo un informe en PDF.

El objetivo principal es ofrecer una herramienta clara, objetiva y fácil de usar para apoyar decisiones personales, académicas o profesionales.

---

## Funcionalidades Principales

### 1. Ingreso del problema
- El usuario puede describir el problema a resolver mediante:
  - Texto
  - Voz (speech-to-text)
- El problema queda almacenado como contexto de la decisión.

### 2. Definición de criterios
- Permite crear criterios de evaluación (ej. costo, tiempo, calidad).
- Cada criterio tiene un peso de importancia configurable (1 a 5).
- Validación para evitar criterios duplicados o vacíos.

### 3. Definición de alternativas
- El usuario registra al menos dos alternativas.
- Las alternativas representan las opciones posibles de decisión.

### 4. Evaluación multicriterio
- Para cada alternativa, el usuario asigna una puntuación por criterio (1 a 5).
- El sistema utiliza la fórmula:
  
  Puntaje = Σ (valor_criterio × peso_criterio)

### 5. Cálculo automático y ranking
- El motor de decisión calcula automáticamente los puntajes totales.
- Se genera un ranking ordenado de mayor a menor.
- La mejor alternativa se resalta visualmente.

### 6. Resultado y explicación
- Se muestra el resultado final de la decisión.
- Incluye:
  - Puntaje total por alternativa
  - Diferencia entre opciones
  - Desglose por criterio
- Se explica por qué una alternativa es la recomendada.

### 7. Aceptación o rechazo de la decisión
- El usuario puede:
  - Aceptar la recomendación
  - Rechazarla y reiniciar el análisis

### 8. Generación de informe PDF
- Al aceptar la decisión, la aplicación genera un informe PDF que incluye:
  - Definición del problema
  - Criterios y pesos
  - Ranking de alternativas
  - Conclusión automática
- El PDF puede compartirse externamente (ej. WhatsApp).

---

## Arquitectura del Proyecto

Proyecto Flutter con estructura estándar:

- lib/main.dart → Punto de entrada de la aplicación
- lib/app_state.dart → Estado global (criterios, alternativas, evaluaciones)
- lib/screens/ → Pantallas principales
  - home_screen.dart
  - criteria_input_screen.dart
  - alternatives_screen.dart
  - evaluation_screen.dart
  - result_screen.dart
  - analysis_detail_screen.dart
- lib/models/ → Modelos de dominio
  - criterio.dart
  - alternativa.dart
  - evaluacion.dart
- lib/services/ → Lógica de negocio
  - decision_engine.dart
  - pdf_generator.dart
  - speech_service.dart

---

## Tecnologías Utilizadas
- Flutter (Material 3)
- Dart
- Android SDK
- Speech-to-Text
- Generación de PDF
- Git + GitHub

---

## Ejecución del Proyecto

### Requisitos
- Flutter SDK instalado
- Android Studio
- Emulador Android o dispositivo físico

### Comandos básicos
flutter pub get  
flutter run  

Para generar APK:
flutter build apk --debug

---

## Publicación
El proyecto se encuentra publicado en GitHub y el APK puede descargarse desde la sección Releases para pruebas directas en dispositivos Android.

---

## Enfoque Metodológico
El desarrollo siguió un proceso iterativo guiado por IA:
- Análisis del dominio de toma de decisiones
- Diseño funcional
- Implementación incremental
- Pruebas continuas
- Refinamiento de UX y lógica de negocio

---

## Autor
Proyecto académico desarrollado como aplicación demostrativa de toma de decisiones multicriterio.

