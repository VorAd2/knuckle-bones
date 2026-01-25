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
      final query = await _firestore
          .collection('codes')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw RoomNotFoundException('Room not found');
      }

      final data = query.docs.first.data();
      final status = data['status'];

      if (status != CodeStatus.virgin) {
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
    await _firestore.collection('codes').add({
      'code': roomCode,
      'status': CodeStatus.virgin.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return roomCode;
  }

  Future<String> createRoom(String hostId, String roomCode) async {
    final docRef = await _firestore.collection('rooms').add({
      'code': roomCode,
      'hostId': hostId,
      'guestId': null,
      'status': MatchStatus.waiting.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  Future<String> joinRoom(String roomCode, String guestId) async {
    final codeQuery = await _firestore
        .collection('codes')
        .where('code', isEqualTo: roomCode)
        .where('status', isEqualTo: CodeStatus.virgin.name)
        .limit(1)
        .get();
    if (codeQuery.docs.isEmpty) {
      throw Exception('Sala não encontrada ou já cheia.');
    }

    final roomQuery = await _firestore
        .collection('rooms')
        .where('code', isEqualTo: roomCode)
        .where('status', isEqualTo: MatchStatus.waiting.name)
        .limit(1)
        .get();
    final docRef = roomQuery.docs.first.reference;
    await docRef.update({
      'guestId': guestId,
      'status': MatchStatus.playing.name,
    });

    return docRef.id;
  }
}
