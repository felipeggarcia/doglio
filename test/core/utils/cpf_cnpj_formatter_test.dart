import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/core/utils/cpf_cnpj_formatter.dart';

void main() {
  group('onlyDigits', () {
    test('remove máscara, mantendo só dígitos', () {
      expect(onlyDigits('123.456.789-09'), '12345678909');
      expect(onlyDigits('11.222.333/0001-44'), '11222333000144');
      expect(onlyDigits(''), '');
    });
  });

  group('formatCpfCnpj', () {
    test('formata CPF (11 dígitos)', () {
      expect(formatCpfCnpj('12345678909'), '123.456.789-09');
    });

    test('formata CPF parcial enquanto digita', () {
      expect(formatCpfCnpj('123456'), '123.456');
      expect(formatCpfCnpj('1234567'), '123.456.7');
    });

    test('formata CNPJ (14 dígitos)', () {
      expect(formatCpfCnpj('11222333000144'), '11.222.333/0001-44');
    });

    test('ignora dígitos além de 14', () {
      expect(formatCpfCnpj('1122233300014499999'), '11.222.333/0001-44');
    });

    test('aceita entrada já mascarada (reformata)', () {
      expect(formatCpfCnpj('123.456.789-09'), '123.456.789-09');
    });
  });

  group('CpfCnpjInputFormatter', () {
    test('mascara o texto digitado e posiciona o cursor no fim', () {
      final formatter = CpfCnpjInputFormatter();
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '12345678909'),
      );
      expect(result.text, '123.456.789-09');
      expect(result.selection.baseOffset, '123.456.789-09'.length);
    });
  });
}
