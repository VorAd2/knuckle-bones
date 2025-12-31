import 'package:flutter/material.dart';

class TileUiState {
  int? value;
  final int rowIndex;
  final int columnIndex;
  final VoidCallback onSelected;

  TileUiState({
    required this.value,
    required this.columnIndex,
    required this.rowIndex,
    required this.onSelected,
  });
}
