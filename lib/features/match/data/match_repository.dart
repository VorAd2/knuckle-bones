import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:knuckle_bones/features/match/types/match_types.dart';

class MatchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
