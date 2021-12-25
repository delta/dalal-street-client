import 'package:get_it/get_it.dart';

/// ## Dependency Injection
///
/// ### Registering objects
/// #### Register objects to then read them from anywhere in the project
/// ```dart
/// // Most of the time getIt can differentiate between objects from thier Type
/// getIt.registerSingleton<String>(sessionId);
/// // Or like this, as type can be inferred in dart
/// getIt.registerSingleton(sessionId);
///
/// // But if you have multiple objects of same type, then mention a name
/// getIt.registerSingleton(sessionId);
/// getIt.registerSingleton(someOtherString, instanceName: 'String 2');
/// ```
///
/// ### Reading objects
/// #### Warning: Trying to read unregistered objects will throw exception
/// ```dart
/// final sessionId = getIt<String>();
/// // or
/// final String sessionId = getIt();
/// // reading objects registered with a name
/// final String string2 = getIt(instanceName: 'String 2');
/// ```
///
/// ### Unregistering objects
/// ```dart
/// // Unregister objects with thier type
/// getIt.unregister<String>();
/// getIt.unregister<User>();
/// // Can unregister with names
/// getIt.unregister(instanceName: 'String 2');
/// // Or unregister everything:
/// getIt.reset();
/// ```
///
/// For more complex usecases checkout [get_it](https://pub.dev/packages/get_it)
final GetIt getIt = GetIt.I;
