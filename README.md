# Fund Management App 🚀

## 🌐 Demo en Vivo
La aplicación está desplegada y funcional en la siguiente URL:
**[https://fund-management-app-acf8b.web.app](https://fund-management-app-acf8b.web.app)**

---

## 📝 Descripción del Proyecto
**Fund Management App** es una plataforma interactiva diseñada para la gestión de fondos de inversión. Permite a los usuarios explorar diversos fondos, realizar suscripciones (validando saldo disponible y montos mínimos), gestionar sus participaciones activas y consultar un historial completo de transacciones.

El proyecto está construido bajo los principios de **Arquitectura Limpia (Clean Architecture)**, garantizando un código mantenible, escalable y fácil de probar.

## ✨ Características Funcionales
- **Dashboard de Usuario**: Visualización en tiempo real del saldo disponible y fondos destacados.
- **Suscripción de Fondos**: Proceso de inversión con validaciones de negocio integradas.
- **Cancelación de Participación**: Gestión flexible de inversiones con retorno inmediato al saldo.
- **Historial de Transacciones**: Registro cronológico de movimientos financieros.
- **Preferencias de Notificación**: Opción de elegir canales de comunicación (Email/SMS).
- **Diseño Responsivo**: Interfaz optimizada para una experiencia fluida tanto en navegadores de escritorio como en dispositivos móviles.

## 🛠️ Stack Tecnológico
- **Framework**: Flutter (Web)
- **Manejo de Estado**: `Provider` (Arquitectura reactiva)
- **Consumo de Datos**: 
    - **Producción**: Consumo de archivos JSON estáticos optimizados.
    - **Desarrollo**: Soporte para `json-server` (Mock API).
- **Hosting e Infraestructura**: Firebase Hosting.
- **Pruebas**: Suite de Unit Testing con `flutter_test`.

## 📐 Arquitectura y Decisiones Técnicas
- **Clean Architecture**: Separación clara de responsabilidades en capas de `Presentation`, `Domain` y `Data`.
- **Desacoplamiento**: Uso de DataSources y Repositorios para permitir cambios en la fuente de datos (API real vs. Mock) sin afectar la lógica de negocio.
- **UI Consistente**: Implementación de un `AppTheme` centralizado basado en estándares de banca digital premium.

---

## 🚀 Cómo Ejecutar el Proyecto

### Prerrequisitos
- **Flutter SDK**: [Guía de instalación](https://docs.flutter.dev/get-started/install)
- **Firebase CLI**: (Opcional, para despliegue) `npm install -g firebase-tools`

### Configuración Local
1. **Clonar el repositorio**
   ```bash
   git clone [https://github.com/tu-usuario/fund_management_app.git](https://github.com/tu-usuario/fund_management_app.git)
   cd fund_management_app
