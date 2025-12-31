import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/match/types/match_types.dart';

class TileUiState {
  final int rowIndex;
  final int columnIndex;
  final VoidCallback onSelected;
  TileStatus role;
  int? value;

  TileUiState({
    required this.role,
    required this.rowIndex,
    required this.columnIndex,
    required this.onSelected,
  });
}
