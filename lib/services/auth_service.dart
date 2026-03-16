import 'package:firebase_auth/firebase_auth.dart';
import 'package:darkness_dungeon/util/logger.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? false;

  // Login con Email y Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      GameLogger.info('Usuario logueado: ${credential.user?.email}');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      GameLogger.error('Error en login: ${e.code}');
      rethrow;
    }
  }

  // Registro con Email y Password
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      GameLogger.info('Usuario registrado: ${credential.user?.email}');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      GameLogger.error('Error en registro: ${e.code}');
      rethrow;
    }
  }

  // Login como Invitado (anónimo)
  Future<User?> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      GameLogger.info('Usuario invitado: ${credential.user?.uid}');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      GameLogger.error('Error en login anónimo: ${e.code}');
      rethrow;
    }
  }

  // Vincular cuenta anónima a email/password (para que el invitado no pierda progreso)
  Future<User?> linkAnonymousToEmail(String email, String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null || !user.isAnonymous) {
        throw Exception('No hay cuenta de invitado activa');
      }
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      final result = await user.linkWithCredential(credential);
      GameLogger.info('Cuenta vinculada: ${result.user?.email}');
      return result.user;
    } on FirebaseAuthException catch (e) {
      GameLogger.error('Error vinculando cuenta: ${e.code}');
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
    GameLogger.info('Sesión cerrada');
  }
}
