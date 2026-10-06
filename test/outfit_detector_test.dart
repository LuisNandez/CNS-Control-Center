import 'package:flutter_test/flutter_test.dart';
import '../lib/services/outfit_detector.dart';

void main() {
  // r(archivos, carpetas): nombres CH_P_EVE_* sin extensión.
  List<String> r(List<String> files, [List<String> dirs = const []]) =>
      OutfitDetector.resolve(files.toSet(), dirs.toSet());

  test('mod real CyberneticBondage_P: traje base + TypeB (2 trajes)', () {
    expect(
        r(['CH_P_EVE_19', 'CH_P_EVE_19_TypeB'],
            ['CH_P_EVE_19', 'CH_P_EVE_ReferenceBody']),
        ['Autonetic Bondage', 'Cybernetic Bondage']);
  });

  test('traje base: archivos propios', () {
    expect(r(['CH_P_EVE_05_Body', 'CH_P_EVE_05_Physics'], ['CH_P_EVE_05']),
        ['Daily Sailor']);
  });

  test('solo variante TypeB: no marca el traje base', () {
    expect(
        r(['CH_P_EVE_05_TypeB', 'CH_P_EVE_05_TypeB_PonytailPhysicsAsset'],
            ['CH_P_EVE_05']),
        ['Comfort Sailor']);
  });

  test('base + TypeB', () {
    expect(r(['CH_P_EVE_05', 'CH_P_EVE_05_TypeB'], ['CH_P_EVE_05']),
        ['Comfort Sailor', 'Daily Sailor']);
  });

  test('varios trajes de carpetas distintas', () {
    expect(
        r(['CH_P_EVE_05', 'CH_P_EVE_20', 'CH_P_EVE_20_TypeC'],
            ['CH_P_EVE_05', 'CH_P_EVE_20']),
        ['Angelic Rose', 'Black Rose', 'Daily Sailor']);
  });

  test('solo carpeta (texturas en subcarpetas): se asume el traje base', () {
    expect(r([], ['CH_P_EVE_05']), ['Daily Sailor']);
  });

  test('09_V02 no se confunde con 09', () {
    expect(r(['CH_P_EVE_09_V02_TypeB'], ['CH_P_EVE_09_V02']),
        ['Planet Diving Protection Suit (7th) V2']);
  });

  test('cuerpo base, pelo y números parecidos no cuentan', () {
    expect(r([], ['CH_P_EVE_01', 'CH_P_EVE_Hair']), isEmpty);
    expect(r(['CH_P_EVE_090']), isEmpty);
  });

  test('asignaciones manuales del usuario', () {
    expect(r(['CH_P_EVE_10', 'CH_P_EVE_10_Physics'], ['CH_P_EVE_10']),
        ['Planet Diving Suit (Captain)']);
    expect(r(['CH_P_EVE_52_TypeB'], ['CH_P_EVE_52']),
        ['FourSeconds Striped Denim']);
    expect(
        r(['CH_P_EVE_Nikke_01_PonytailPhysicsAsset'], ['CH_P_EVE_Nikke_01']),
        ['Wandering Swordfighter Outfit']);
  });
}
