# Fund Management App

## Descripción del Proyecto

**Fund Management App** es una aplicación web desarrollada con **Flutter** que simula una plataforma para la gestión de fondos de inversión. En su estado actual, la aplicación consume los datos desde una API REST simulada y los muestra en una lista.

Este proyecto se está construyendo con un fuerte enfoque en las buenas prácticas de desarrollo de software, incluyendo una **arquitectura limpia** y un **manejo de estado desacoplado**.
---

## Características Implementadas (Hasta ahora)

- **Visualización de Fondos:** Se conecta a una API simulada para obtener y mostrar una lista de fondos de inversión disponibles.
- **Manejo de Estado de Carga:** Muestra un indicador de progreso mientras se obtienen los datos.
- **Arquitectura Limpia:** El código está organizado en capas (`data` y `presentation`) para asegurar que sea escalable, mantenible y fácil de probar.
- **Componentes Reutilizables:** La interfaz se construye a partir de widgets modulares y reutilizables (`FundCard`).

---

## Decisiones de Arquitectura

El proyecto sigue los principios de **Arquitectura Limpia** para separar las responsabilidades:

### Capa de Datos (`data`)

- **Models:** Define las estructuras de datos (`Fund`).
- **Datasources:** Responsable de la obtención de datos brutos desde la API (`FundApiDatasource`).
- **Repositories:** Abstrae el origen de los datos, actuando como el único punto de contacto para la capa de presentación.

### Capa de Presentación (`presentation`)

- **Provider:** Se utiliza para el manejo de estado. `FundProvider` actúa como el "cerebro" que obtiene los datos y notifica a la UI de los cambios.
- **Screens:** Contiene los widgets que representan las pantallas completas (`HomeScreen`).
- **Widgets:** Componentes de UI reutilizables (`FundCard`).

---

## API Simulada (`mock_api`)

Se utiliza **json-server** para simular un backend RESTful.  
Esto permite un desarrollo de frontend desacoplado y realista.

---

## Cómo Ejecutar el Proyecto

Sigue estos pasos para configurar y ejecutar el proyecto en tu máquina local.

### Prerrequisitos

Asegúrate de tener instalado lo siguiente:

- **Flutter SDK:** [Instrucciones de instalación para Web](https://docs.flutter.dev/get-started/web)
- **Node.js y npm:** [Descargar Node.js](https://nodejs.org/) (npm se incluye con Node.js)

---

### Pasos de Instalación y Ejecución

#### 1. Clonar el Repositorio

```bash
git clone <URL_DE_TU_REPOSITORIO_EN_GITHUB>
cd fund_management_app
```

#### 2. Instalar Dependencias de Flutter

Este comando leerá tu archivo `pubspec.yaml` y descargará todos los paquetes necesarios (`http`, `provider`, etc.).

```bash
flutter pub get
```

#### 3. Configurar y Ejecutar la API Simulada

El proyecto incluye una carpeta `mock_api` con todo lo necesario para simular el backend.

##### Paso 3a: Navegar a la carpeta de la API

En una primera terminal, navega a la carpeta `mock_api`.

```bash
cd mock_api
```

##### Paso 3b: Instalar dependencias del servidor

Este comando leerá el archivo `package.json` e instalará `json-server`.

```bash
npm install
```

##### Paso 3c: Iniciar el servidor

Este comando iniciará la API. Debería estar disponible en [http://localhost:3000/data](http://localhost:3000/data).

```bash
npm start
```

¡Deja esta terminal abierta y corriendo!

#### 4. Ejecutar la Aplicación Flutter

Abre una segunda terminal en la raíz del proyecto y ejecuta la aplicación en el navegador Chrome:

```bash
flutter run -d chrome
```

¡Y listo! La aplicación debería iniciarse y mostrar la lista de fondos desde tu servidor local.
