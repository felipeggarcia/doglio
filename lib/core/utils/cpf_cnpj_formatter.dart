/// Utilitários de máscara para CPF/CNPJ.
///
/// Regra: a UI mostra com máscara (000.000.000-00 / 00.000.000/0000-00),
/// mas a API sempre recebe apenas dígitos.
library;

import 'package:flutter/services.dart';

/// Remove tudo que não for dígito.
String onlyDigits(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');

/// Formata uma string de dígitos como CPF (≤11) ou CNPJ (12–14).
String formatCpfCnpj(String value) {
  final digits = onlyDigits(value);
  final capped = digits.length > 14 ? digits.substring(0, 14) : digits;

  final buffer = StringBuffer();
  if (capped.length <= 11) {
    // CPF: 000.000.000-00
    for (var i = 0; i < capped.length; i++) {
      if (i == 3 || i == 6) buffer.write('.');
      if (i == 9) buffer.write('-');
      buffer.write(capped[i]);
    }
  } else {
    // CNPJ: 00.000.000/0000-00
    for (var i = 0; i < capped.length; i++) {
      if (i == 2 || i == 5) buffer.write('.');
      if (i == 8) buffer.write('/');
      if (i == 12) buffer.write('-');
      buffer.write(capped[i]);
    }
  }
  return buffer.toString();
}

/// Aplica a máscara de CPF/CNPJ enquanto o usuário digita.
/// O texto exibido fica mascarado; o valor real (dígitos) é obtido com
/// [onlyDigits] na hora de enviar à API.
class CpfCnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = formatCpfCnpj(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
