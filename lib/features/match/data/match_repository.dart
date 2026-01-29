import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:knuckle_bones/core/domain/player_role.dart';
import 'package:knuckle_bones/features/match/data/mappers.dart';
import 'package:knuckle_bones/features/match/domain/entity/board_entity.dart';
import 'package:knuckle_bones/features/match/domain/entity/room_entity.dart';
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
        throw RoomUsedException('This code is invalid');
      }
    } on RoomNotFoundException {
      rethrow;
    } on RoomUsedException {
      rethrow;
    } catch (e) {
      throw Exception("Unknown error. Please, contact the developer.");
    }
  }

  Future<String> insertCode({
    required String roomCode,
    required String roomId,
  }) async {
    await _firestore.collection('codes').doc(roomCode).set({
      'code': roomCode,
      'status': CodeStatus.virgin.name,
      'room': roomId,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return roomCode;
  }

  Future<String> createRoom({
    required String roomCode,
    required String hostId,
    required String hostName,
  }) async {
    final docRef = await _firestore.collection('rooms').add({
      'code': roomCode,
      'hostBoard': BoardEntity(
        playerId: hostId,
        playerName: hostName,
        omen: null,
        score: null,
      ).toMap(),
      'guestBoard': null,
      'status': MatchStatus.waiting.name,
      'turnPlayerId': hostId,
      'isOmen': false,
      'lastMove': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  Future<Map<String, dynamic>> joinRoom({
    required String roomCode,
    required String guestId,
    required String guestName,
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
        'status': MatchStatus.playing.name,
        'guestBoard': BoardEntity(
          playerId: guestId,
          playerName: guestName,
          omen: null,
          score: null,
        ).toMap(),
        'turnPlayerId': freshRoom.data()?['hostBoard']['playerId'],
      });
      transaction.update(codeRef, {'status': CodeStatus.used.name});
    });

    final oldRoomData = roomQuerySnapshot.docs.first.data();
    return {'id': roomRef.id, 'hostBoard': oldRoomData['hostBoard']};
  }

  Stream<RoomEntity> streamMatch(String roomId) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .snapshots(includeMetadataChanges: true)
        .where((snapshot) => !snapshot.metadata.hasPendingWrites)
        .map((snapshot) {
          if (!snapshot.exists) throw Exception('The game was finished');
          return snapshot.data()!.toRoomEntity(roomId);
        });
  }

  Future<void> echoOmen({
    required RoomEntity room,
    required PlayerRole role,
    required int omen,
  }) async {
    final boardName = role == .host ? 'hostBoard' : 'guestBoard';
    final boardEntity = boardName == 'hostBoard'
        ? room.hostBoard
        : room.guestBoard;
    await _firestore.collection('rooms').doc(room.id).update({
      'isOmen': true,
      boardName: boardEntity!.copyWith(omen: omen).toMap(),
    });
  }

  Future<void> echoMove({required RoomEntity room}) async {
    await _firestore.collection('rooms').doc(room.id).set(room.toMap());
  }
}
