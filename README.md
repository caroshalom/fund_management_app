# Fund Management App

## Descripción del Proyecto

**Fund Management App** es una aplicación web interactiva y responsiva desarrollada con **Flutter** que simula una plataforma para la gestión de fondos de inversión. Permite a un usuario visualizar fondos, suscribirse, cancelar su participación y ver un historial de transacciones.

Este proyecto fue construido siguiendo las mejores prácticas de desarrollo de software, incluyendo una arquitectura limpia, un manejo de estado centralizado con Provider, diseño responsivo, validación de formularios y pruebas unitarias.

## Características Funcionales

- **Visualización de Fondos**: Se conecta a una API simulada para obtener y mostrar una lista de fondos de inversión.
- **Suscripción a Fondos**: Permite al usuario suscribirse a un fondo, validando el monto mínimo y el saldo disponible.
- **Cancelación de Suscripción**: Permite al usuario cancelar su participación en un fondo, restaurando el saldo.
- **Historial de Transacciones**: Muestra un registro cronológico de todas las suscripciones y cancelaciones.
- **Selección de Notificación**: El usuario puede elegir entre Email o SMS al momento de la suscripción.
- **Feedback Visual**: Proporciona mensajes claros de éxito y error, así como estados de carga.

## Decisiones de Arquitectura y Técnicas

- **Lenguaje**: Dart
- **Framework**: Flutter (para Web)
- **Arquitectura**: Arquitectura Limpia, separando la lógica en capas de `data` y `presentation`.
- **Manejo de Estado**: `provider`, para una gestión de estado centralizada y reactiva.
- **Diseño UI/UX**: Basado en la identidad corporativa de BTG Pactual, con un enfoque en la claridad y la experiencia de usuario. Se utiliza un `AppTheme` centralizado.
- **Diseño Responsivo**: Se utiliza un `ListView` para una adaptabilidad natural en diferentes tamaños de pantalla, asegurando una buena experiencia en móvil y web.
- **Consumo de API**: Se utiliza el paquete `http` para comunicarse con una API REST simulada con `json-server`.
- **Pruebas**: Se implementan pruebas unitarias con `flutter_test` para validar la lógica de negocio en el `FundProvider`.

## Cómo Ejecutar el Proyecto

Sigue estos pasos para configurar y ejecutar el proyecto en tu máquina local.

### Prerrequisitos

- **Flutter SDK**: [Instrucciones de instalación para Web](https://docs.flutter.dev/get-started/web)
- **Node.js y npm**: [Descargar Node.js](https://nodejs.org/)

### Pasos de Instalación y Ejecución

1. **Clonar el Repositorio**
```bash
git clone <URL_DE_TU_REPOSITORIO_EN_GITHUB>
cd fund_management_app
```

2. **Instalar Dependencias de Flutter**
```bash
flutter pub get
```

3. **Configurar y Ejecutar la API Simulada**  
En una primera terminal, navega a la carpeta `mock_api`.

```bash
cd mock_api
npm install
npm start
```

¡Deja esta terminal abierta y corriendo!

4. **Ejecutar la Aplicación Flutter**  
En una segunda terminal, en la raíz del proyecto, ejecuta la aplicación.

```bash
flutter run -d chrome
```

5. **Ejecutar las Pruebas Unitarias**
```bash
flutter test
```
