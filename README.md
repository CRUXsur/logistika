# logistika

A Flutter application designed for logistics management. It includes features such as customer management, warehouse management, distribution, routes, and sales force management.


## Getting Started
Esta aplicacion esta desarrollada para celulares iOS y Android.
La informacion obtenida queda segura guardada y disponible en una base de datos.

### Prerequisites
- Flutter SDK: Make sure you have the Flutter SDK installed. You can find installation instructions on the [official Flutter website](https://flutter.dev/docs/get-started/install).

### Installation
1. Clone the repository: `git clone <repository_url>`
2. Navigate to the project directory: `cd logistika`
3. Install dependencies: `flutter pub get`

## Running the app

To run the application, ensure you have a connected device (emulator or physical device) or a configured web browser. Then, execute the following command in the root project directory:

```bash
flutter run
```

This command will launch the application on the selected device/platform.

## Running tests

This project includes widget tests. To run these tests, execute the following command in the root project directory:

```bash
flutter test
```

## Project Structure

A typical Flutter project has the following structure:

-   `lib/`: Contains the Dart code for the application.
    -   `main.dart`: The entry point of the application.
    -   `widgets/`: Contains custom widgets used throughout the application.
    -   `admin/`: Contains models, providers and screens for admin panel.
    -   `api_connection/`: Contains API connection logic.
-   `android/`: Contains Android-specific project files.
-   `ios/`: Contains iOS-specific project files.
-   `web/`: Contains web-specific project files (if configured).
-   `macos/`: Contains macOS-specific project files (if configured).
-   `windows/`: Contains Windows-specific project files (if configured).
-   `linux/`: Contains Linux-specific project files (if configured).
-   `test/`: Contains unit and widget tests.
-   `assets/`: Contains static assets like images, fonts, etc.
-   `pubspec.yaml`: Defines project metadata and dependencies.

## Features

-   **CLIENTES**: Registro, Cotizaciones, Ventas, Cobros
-   **ALMACEN**: Inventarios, Costos, Precios, Ingresos, Egresos
-   **DISTRIBUCION**: Ventas/Entregas
-   **RUTAS**: Visitas/Pedidos
-   **VENDEDORES**: Registro


