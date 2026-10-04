import 'package:flutter_test/flutter_test.dart';
import '../lib/services/nexus_file_identifier.dart';

void main() {
  group('NexusFileNameParser.parse', () {
    test('archivo normal de la pestaña Files', () {
      final c = NexusFileNameParser.parse(
          'Neurolink Suit Titties Out Replacer-1234-1-0-1759300260.zip');
      expect(c.first.name, 'Neurolink Suit Titties Out Replacer');
      expect(c.first.modId, '1234');
      expect(c.first.version, '1.0');
      expect(c.first.timestamp, '1759300260');
    });

    test('ignora el sufijo (1) que añade el navegador', () {
      final c = NexusFileNameParser.parse(
          'Neurolink Suit Titties Out CNS-1234-1-0-1759300260 (1).zip');
      expect(c.first.name, 'Neurolink Suit Titties Out CNS');
      expect(c.first.modId, '1234');
    });

    test('nombre con números separados por guiones', () {
      final c = NexusFileNameParser.parse('Outfit-2-Pack-5678-2-1-3-1759300260.7z');
      expect(c.first.name, 'Outfit-2-Pack');
      expect(c.first.modId, '5678');
      expect(c.first.version, '2.1.3');
    });

    test('versiones con sufijo y prefijo v', () {
      expect(NexusFileNameParser.parse('My Mod-99-1-0-beta-1759300260.zip').first.version,
          '1.0-beta');
      expect(NexusFileNameParser.parse('My Mod-99-v1-5-1759300260.zip').first.version,
          '1.5');
    });

    test('nombre generado por el gestor (timestamp 0)', () {
      final c = NexusFileNameParser.parse('Foo-1234-1-0-0.zip');
      expect(c.first.modId, '1234');
      expect(c.first.timestamp, '0');
    });

    test('archivo que no es de Nexus', () {
      expect(NexusFileNameParser.parse('random mod name.zip'), isEmpty);
      expect(NexusFileNameParser.bestGuess('random mod name.zip'), isNull);
    });
  });

  group('sanitizeDisplayName', () {
    test('quita la versión final y caracteres inválidos', () {
      expect(NexusFileNameParser.sanitizeDisplayName('Neurolink Suit v1.0', version: '1.0'),
          'Neurolink Suit');
      expect(NexusFileNameParser.sanitizeDisplayName('Foo: Bar?'), 'Foo- Bar-');
    });

    test('no recorta números que forman parte del nombre', () {
      expect(NexusFileNameParser.sanitizeDisplayName('Outfit Pack 2', version: '2'),
          'Outfit Pack 2');
    });
  });
}