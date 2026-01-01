import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/match/types/match_types.dart';

class TileUiState {
  final int rowIndex;
  final int columnIndex;
  final VoidCallback onSelected;
  TileStatus status;
  int? value;
  bool isDestroying;

  TileUiState({
    required this.status,
    required this.rowIndex,
    required this.columnIndex,
    required this.onSelected,
    this.isDestroying = false,
  });
}
