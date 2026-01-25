import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:knuckle_bones/features/match/types/match_types.dart';

class RoomNotFoundException implements Exception {
  final String message;
  RoomNotFoundException(this.message);
  @override
  String toString() => message;
}

class RoomUsedException implements Exception {
  final String message;
  RoomUsedException(this.message);
  @override
  String toString() => message;
}

class MatchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> checkCodeAvailability(String code) async {
    try {
      final docSnapshot = await _firestore.collection('codes').doc(code).get();

      if (!docSnapshot.exists) {
        throw RoomNotFoundException('Room not found');
      }

      final data = docSnapshot.data();
      final status = data?['status'];

      if (status != CodeStatus.virgin.name) {
        throw RoomUsedException('This code is already in use or is invalid');
      }
    } on RoomNotFoundException {
      rethrow;
    } on RoomUsedException {
      rethrow;
    } catch (e) {
      throw Exception("Unknown error. Please, contact the developer.");
    }
  }

  Future<String> insertCode(String roomCode) async {
    await _firestore.collection('codes').doc(roomCode).set({
      'code': roomCode,
      'status': CodeStatus.virgin.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return roomCode;
  }

  Future<String> createRoom({
    required String hostId,
    required String roomCode,
  }) async {
    final docRef = await _firestore.collection('rooms').add({
      'code': roomCode,
      'hostId': hostId,
      'guestId': null,
      'status': MatchStatus.waiting.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  Future<String> joinRoom({
    required String roomCode,
    required String guestId,
  }) async {
    final roomQueryFuture = _firestore
        .collection('rooms')
        .where('code', isEqualTo: roomCode)
        .where('status', isEqualTo: MatchStatus.waiting.name)
        .limit(1)
        .get();

    final codeRef = _firestore.collection('codes').doc(roomCode);
    final futureCodeSnapshot = codeRef.get();

    final results = await Future.wait([roomQueryFuture, futureCodeSnapshot]);
    final roomQuerySnapshot = results[0] as QuerySnapshot<Map<String, dynamic>>;
    final codeSnapshot = results[1] as DocumentSnapshot<Map<String, dynamic>>;

    if (roomQuerySnapshot.docs.isEmpty || !codeSnapshot.exists) {
      throw Exception(
        'Sala não encontrada, código inválido ou jogo já iniciado.',
      );
    }

    final roomRef = roomQuerySnapshot.docs.first.reference;

    await _firestore.runTransaction((transaction) async {
      final freshRoom = await transaction.get(roomRef);
      final freshCode = await transaction.get(codeRef);
      if (!freshRoom.exists || !freshCode.exists) {
        throw Exception('Inconsistent data');
      }

      if (freshRoom.data()?['status'] != MatchStatus.waiting.name ||
          freshCode.data()?['status'] != CodeStatus.virgin.name) {
        throw Exception('The room has just been occupied');
      }

      transaction.update(roomRef, {
        'guestId': guestId,
        'status': MatchStatus.playing.name,
      });
      transaction.update(codeRef, {'status': CodeStatus.used.name});
    });

    return roomRef.id;
  }
}
