import 'package:flutter/material.dart';

enum TileRole { alone, paired }

class TileUiState {
  final int rowIndex;
  final int columnIndex;
  final VoidCallback onSelected;
  TileRole role;
  int? value;

  TileUiState({
    required this.role,
    required this.rowIndex,
    required this.columnIndex,
    required this.onSelected,
  });
}
