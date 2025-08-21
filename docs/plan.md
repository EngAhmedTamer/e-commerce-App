# Clean Architecture for Flutter Applications: A Comprehensive Guide

Clean Architecture, popularized by Robert C. Martin (Uncle Bob), advocates for a layered approach to software design, emphasizing separation of concerns and a strict dependency rule: **inner layers must not depend on outer layers.** This leads to systems that are independent of UI, database, frameworks, and external agencies, making them highly testable, maintainable, and flexible.

### Why Clean Architecture?

*   **Testability**: Business rules can be tested independently of UI, database, or web.
*   **Maintainability**: Changes in one layer (e.g., UI framework) do not impact other layers (e.g., business logic).
*   **Flexibility**: Easy to swap out external dependencies (database, UI framework, external APIs).
*   **Scalability**: Well-defined boundaries facilitate adding new features without disrupting existing ones.
*   **Team Collaboration**: Clear responsibilities for each layer reduce conflicts and improve development efficiency.

### Core Principles

1.  **Separation of Concerns**: Each layer has a distinct responsibility.
2.  **Dependency Rule**: Dependencies always flow inwards. Inner layers have no knowledge of outer layers. This is often achieved using the Dependency Inversion Principle (DIP).

### Proposed Layered Structure for `ecommerce` Project

We'll adapt the typical Clean Architecture layers for a Flutter application:

1.  **Domain Layer (Core Business Rules)**
    *   **Purpose**: Contains the core business logic and entities. This layer is entirely pure Dart, with no Flutter, database, or network dependencies.
    *   **Contents**:
        *   `entities`: Plain Dart objects representing core business concepts (e.g., `CartEntity`, `UserEntity`).
        *   `usecases`: Application-specific business rules. They orchestrate data flow using abstract repository interfaces. (e.g., `CartUseCase`, `AuthenticateUserUseCase`).
        *   `repositories` (abstract interfaces): Abstract definitions of operations that data layers must implement (e.g., `CartRepository`, `AuthRepository`). These interfaces define *what* data operations are needed by the business logic, not *how* they are performed.

2.  **Data Layer (Implementation of Data Abstraction)**
    *   **Purpose**: Implements the abstract repository interfaces defined in the Domain layer. It deals with external data sources (APIs, databases).
    *   **Contents**:
        *   `models`: Data Transfer Objects (DTOs) or concrete data models that closely map to raw data from external sources (e.g., Supabase JSON responses). These models are responsible for `fromJson`/`toJson` conversions.
        *   `data_sources`: Classes that directly interact with external APIs or databases (e.g., `SupabaseAuthDataSource`, `SupabaseProductDataSource`).
        *   `repositories` (concrete implementations): Implementations of the abstract repository interfaces from the Domain layer. They coordinate `data_sources` and map `models` to `entities`.

3.  **Presentation Layer (UI and UI Logic)**
    *   **Purpose**: Manages the user interface and handles user interactions. It d0epends on the Domain layer's `usecases` to perform actions.
    *   **Contents**:
        *   `pages` / `views`: Flutter widgets responsible for rendering the UI.
        *   `blocs` / `cubits` / `viewmodels` / `providers`: State management classes (depending on your chosen state management solution) that consume `usecases`, manage UI state, and expose data to the `views`. They do not contain core business logic.

4.  **Dependency Injection (DI)**
    *   **Purpose**: Manages the creation and provision of dependencies throughout the application. It connects the concrete implementations from outer layers to the abstract interfaces required by inner layers.
    *   **Contents**: Typically a dedicated file or module (e.g., `lib/di.dart` or `lib/core/di/di_container.dart`) where all dependencies are registered and resolved. This is where you'll tell your app to use `SupabaseProductRepositoryImpl` when `ProductRepository` is requested.

### Proposed Directory Structure

To implement the above layers, use a modular, scalable layout that cleanly separates app-level concerns, shared utilities, and per-feature code:

```
lib/
├── main.dart                 # Application entry point, DI bootstrap
├── app/                      # App-level composition (routing, themes, localization)
│   ├── app.dart              # Root widget and MaterialApp
│   ├── router/
│   │   └── app_router.dart   # GoRouter/RouteInformationParser config
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── colors.dart
│   └── localization/
│       └── l10n.dart         # (optional) localization helpers
├── core/                     # Pure, framework-agnostic building blocks
│   ├── error/                # Failures/exceptions abstractions
│   ├── network/              # Network client, interceptors, connectivity
│   ├── usecase/              # Base UseCase and NoParams
│   ├── utils/                # Small helpers, formatters, guards
│   ├── constants/            # App-wide constants (keys, timeouts, etc.)
│   └── services/             # Cross-cutting services (e.g., logger)
├── di.dart                   # Dependency injection registrations (get_it)
├── shared/                   # UI and logic reused across features
│   ├── widgets/              # Reusable widgets (Buttons, Loaders, etc.)
│   ├── extensions/           # Dart/Flutter extensions
│   └── mixins/               # Common mixins
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── models/         # DTOs with fromJson/toJson, toEntity()
    │   │   ├── datasources/    # Remote/local data sources (Supabase, cache)
    │   │   └── repositories/   # Implementations of domain repositories
    │   ├── domain/
    │   │   ├── entities/       # Pure entities (UserEntity)
    │   │   ├── repositories/   # Abstract repository interfaces
    │   │   └── usecases/       # Feature use cases
    │   └── presentation/
    │       ├── pages/          # Screens (LoginPage, RegisterPage, SplashScreen)
    │       ├── widgets/        # Feature-specific widgets
    │       └── view_models/    # ViewModels/Blocs/Cubits/Providers
    └── items/
        ├── data/
        │   ├── models/         # ProductModel, etc.
        │   ├── datasources/    # ProductRemoteDataSource
        │   └── repositories/   # ProductRepositoryImpl
        ├── domain/
        │   ├── entities/       # ProductEntity
        │   ├── repositories/   # product_repository.dart
        │   └── usecases/       # GetProductsUseCase, etc.
        └── presentation/
            ├── pages/          # ProductListPage, ProductDetailPage
            ├── widgets/        # Feature-specific widgets
            └── view_models/    # ItemsViewModel (or Bloc/Cubit/Provider)
```

Notes:
- Keep `di.dart` at the root to match the DI setup referenced later; you can move it under `core/di/` if you prefer, but update imports accordingly.
- The `app/` folder centralizes routing, theming, and localization to keep features focused on business/UI logic.
- The `shared/` folder avoids duplication of cross-feature UI components and helpers.

### Migration Steps

Here's a step-by-step approach to refactor your existing `ecommerce` project:

#### Step 1: Define Domain Layer

1.  **Create `entities`**:
    *   Go to `lib/features/items/model/product.dart`. Rename `Product` to `ProductEntity` and move it to `lib/features/items/domain/entities/product_entity.dart`.
    *   Ensure `ProductEntity` is a pure Dart class with no `fromJson`/`toJson` or other framework-specific code. If it had such code, remove it or create a new `ProductModel` for the Data layer.
    *   Similarly, create `UserEntity` in `lib/features/auth/domain/entities/user_entity.dart` for authentication.

2.  **Define `repository` interfaces**:
    *   Create `lib/features/items/domain/repositories/product_repository.dart`:
        ```dart
        abstract class ProductRepository {
          Future<List<ProductEntity>> getProducts();
          Future<ProductEntity> getProductDetails(String productId);
          // Define other product-related operations
        }
        ```
    *   Create `lib/features/auth/domain/repositories/auth_repository.dart`:
        ```dart
        abstract class AuthRepository {
          Future<UserEntity> login(String email, String password);
          Future<void> logout();
          Future<bool> isAuthenticated();
        }
        ```

3.  **Create `usecases`**:
    *   Create `lib/features/items/domain/usecases/get_products_usecase.dart`:
        ```dart
        import '../../../../core/usecase/usecase.dart'; // Create a base UseCase first
        import '../entities/product_entity.dart';
        import '../repositories/product_repository.dart';

        class GetProductsUseCase implements UseCase<List<ProductEntity>, NoParams> {
          final ProductRepository repository;

          GetProductsUseCase(this.repository);

          @override
          Future<List<ProductEntity>> call(NoParams params) async {
            return await repository.getProducts();
          }
        }
        ```
    *   Create `lib/features/auth/domain/usecases/authenticate_user_usecase.dart`:
        ```dart
        import '../../../../core/usecase/usecase.dart';
        import '../entities/user_entity.dart';
        import '../repositories/auth_repository.dart';

        class AuthenticateUserUseCase implements UseCase<UserEntity, AuthParams> {
          final AuthRepository repository;

          AuthenticateUserUseCase(this.repository);

          @override
          Future<UserEntity> call(AuthParams params) async {
            return await repository.login(params.email, params.password);
          }
        }

        class AuthParams {
          final String email;
          final String password;
          AuthParams(this.email, this.password);
        }
        ```
    *   **Create a Base `UseCase` (in `lib/core/usecase/usecase.dart`)**:
        ```dart
        import 'package:equatable/equatable.dart';

        abstract class UseCase<Type, Params> {
          Future<Type> call(Params params);
        }

        class NoParams extends Equatable {
          @override
          List<Object?> get props => [];
        }
        // You might also define Failure/Either for error handling here or in a core/error folder.
        ```

#### Step 2: Implement Data Layer

1.  **Create `models`**:
    *   If `product.dart` had `fromJson`/`toJson`, split it. Create `lib/features/items/data/models/product_model.dart` which directly maps to your Supabase response structure and includes `fromJson`/`toJson`.
    *   Add a `toEntity()` method to `ProductModel` to convert it to `ProductEntity`.
    *   Similarly for authentication, create `UserModel` if needed.

2.  **Create `data_sources`**:
    *   Create `lib/features/items/data/datasources/product_remote_data_source.dart`. This class will directly interact with your Supabase client to fetch raw product data (e.g., `supabase.from('products').select().execute()`).
    *   Create `lib/features/auth/data/datasources/auth_remote_data_source.dart` for Supabase auth operations.

3.  **Implement `repository` interfaces**:
    *   Create `lib/features/items/data/repositories/product_repository_impl.dart`:
        ```dart
        import '../../domain/entities/product_entity.dart';
        import '../../domain/repositories/product_repository.dart';
        import '../datasources/product_remote_data_source.dart';
        import '../models/product_model.dart';

        class ProductRepositoryImpl implements ProductRepository {
          final ProductRemoteDataSource remoteDataSource;

          ProductRepositoryImpl(this.remoteDataSource);

          @override
          Future<List<ProductEntity>> getProducts() async {
            final productModels = await remoteDataSource.getProducts();
            return productModels.map((model) => model.toEntity()).toList();
          }
          // Implement other methods and handle errors (e.g., network issues)
        }
        ```
    *   Do the same for `AuthRepositoryImpl`.

#### Step 3: Adapt Presentation Layer

1.  **Modify `view_model`s**:
    *   Go to `lib/features/auth/view_model/auth_view_model.dart`.
    *   Instead of calling `auth_repository.dart` directly, inject and call the `AuthenticateUserUseCase` (and other auth use cases).
    *   The `ViewModel` should now primarily manage UI state and trigger use cases based on user input, then update the state based on use case results.
    *   Rename `view_model` to `blocs` or `providers` if using those patterns for consistency.

2.  **Update `views`/`pages`**:
    *   Ensure your `SplashScreen` and other UI widgets consume data and trigger actions via their respective `ViewModel`/Bloc. The UI should remain "dumb" – reacting to state changes.

#### Step 4: Setup Dependency Injection

1.  **Install a DI package**: Add `get_it` or `injectable` to your `pubspec.yaml`.
        ```yaml
        dependencies:
          get_it: ^7.6.0
          # injectable: ^2.4.0 (if you prefer code generation)
        ```

2.  **Create `lib/di.dart`**:
        ```dart
        import 'package:get_it/get_it.dart';
        import 'package:supabase_flutter/supabase_flutter.dart';

        import 'features/auth/data/datasources/auth_remote_data_source.dart';
        import 'features/auth/data/repositories/auth_repository_impl.dart';
        import 'features/auth/domain/repositories/auth_repository.dart';
        import 'features/auth/domain/usecases/authenticate_user_usecase.dart';
        import 'features/auth/presentation/view_models/auth_view_model.dart'; // Assuming AuthViewModel

        import 'features/items/data/datasources/product_remote_data_source.dart';
        import 'features/items/data/repositories/product_repository_impl.dart';
        import 'features/items/domain/repositories/product_repository.dart';
        import 'features/items/domain/usecases/get_products_usecase.dart';
        import 'features/items/presentation/view_models/items_view_model.dart'; // Assuming ItemsViewModel

        final sl = GetIt.instance; // sl = Service Locator

        Future<void> initDependencies() async {
          // External dependencies
          sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

          // Feature: Auth
          // Data Sources
          sl.registerLazySingleton<AuthRemoteDataSource>(
            () => AuthRemoteDataSourceImpl(client: sl()), // Pass SupabaseClient
          );
          // Repositories
          sl.registerLazySingleton<AuthRepository>(
            () => AuthRepositoryImpl(remoteDataSource: sl()),
          );
          // Use Cases
          sl.registerLazySingleton<AuthenticateUserUseCase>(
            () => AuthenticateUserUseCase(sl()),
          );
          // ViewModels/Blocs (register as factory if they manage state per screen)
          sl.registerFactory<AuthViewModel>(
            () => AuthViewModel(authenticateUserUseCase: sl()),
          );

          // Feature: Items
          // Data Sources
          sl.registerLazySingleton<ProductRemoteDataSource>(
            () => ProductRemoteDataSourceImpl(client: sl()),
          );
          // Repositories
          sl.registerLazySingleton<ProductRepository>(
            () => ProductRepositoryImpl(remoteDataSource: sl()),
          );
          // Use Cases
          sl.registerLazySingleton<GetProductsUseCase>(
            () => GetProductsUseCase(sl()),
          );
          // ViewModels/Blocs
          sl.registerFactory<ItemsViewModel>(
            () => ItemsViewModel(getProductsUseCase: sl()),
          );
        }
        ```

3.  **Update `main.dart`**:
    *   Call `initDependencies()` before `runApp`.
        ```dart
        import 'package:flutter/material.dart';
        import 'package:supabase_flutter/supabase_flutter.dart';
        import 'package:ecommerce/di.dart' as di; // Import your DI setup

        import 'features/auth/presentation/pages/splash_screen.dart'; // Updated path

        void main() async {
          WidgetsFlutterBinding.ensureInitialized();

          await Supabase.initialize(
            url: 'https://lveprsmocrkywpkphwbf.supabase.co',
            anonKey: 'YOUR_ANON_KEY', // Use environment variables for production!
          );

          await di.initDependencies(); // Initialize your dependencies

          runApp(const MyApp());
        }

        class MyApp extends StatelessWidget {
          const MyApp({super.key});

          @override
          Widget build(BuildContext context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Elegant Login UI',
              theme: ThemeData(
                fontFamily: 'Roboto',
                brightness: Brightness.light,
                primarySwatch: Colors.indigo,
              ),
              home: const SplashScreen(), // Ensure SplashScreen gets its ViewModel via DI if needed
            );
          }
        }
        ```

#### Step 5: Refactor and Test Iteratively

*   Start with one feature (e.g., `auth`) and refactor it completely before moving to `items`.
*   Write unit tests for Use Cases and Repository implementations.
*   Write widget tests for your `ViewModels`/Blocs and integration tests for features.

### Benefits of the Refactored Architecture

*   **Maximum Testability**: Each layer can be tested in isolation. Use Cases can be tested without a UI or database.
*   **High Maintainability**: Changes in data sources (e.g., migrating from Supabase to another backend) only affect the Data layer. UI changes are confined to the Presentation layer.
*   **Framework Independence**: Core business logic (`Domain` layer) is pure Dart, making it potentially reusable in other Dart applications (e.g., a backend, a command-line tool).
*   **Clear Responsibilities**: Every class has a single, well-defined purpose, reducing cognitive load and making onboarding new developers easier.
*   **Scalability**: New features can be added by extending existing layers without significant modifications to core components.
