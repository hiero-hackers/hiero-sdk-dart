import 'package:decimal/decimal.dart';
import 'package:hiero_sdk_dart/src/hbar.dart';
import 'package:hiero_sdk_dart/src/hbar_unit.dart';
import 'package:test/test.dart';

void main() {
  group('Hbar unit tests', () {
    test('testConstructor', () {
      // Test creation with int, double, and Decimal values in hbars.
      final hbar1 = Hbar(50);
      expect(hbar1.toTinybars(), 5000000000);
      expect(hbar1.toHbars(), 50.0);

      final hbar2 = Hbar(0.5);
      expect(hbar2.toTinybars(), 50000000);
      expect(hbar2.toHbars(), 0.5);

      final hbar3 = Hbar(Decimal.parse('0.5'));
      expect(hbar3.toTinybars(), 50000000);
      expect(hbar3.toHbars(), 0.5);
    });

    test('testConstructorInvalidAmountType', () {
      // Test creation with invalid type raise errors.
      expect(() => Hbar('1'), throwsArgumentError);
      expect(() => Hbar(true), throwsArgumentError);
      expect(() => Hbar(false), throwsArgumentError);
      expect(() => Hbar({}), throwsArgumentError);
      expect(() => Hbar(Object()), throwsArgumentError);
    });

    test('testConstructorNonFiniteAmountValue', () {
      // Test creation raise errors for non finite amount.
      expect(() => Hbar(double.infinity), throwsArgumentError);
      expect(() => Hbar(double.nan), throwsArgumentError);
    });

    test('testConstructorWithTinybarUnit', () {
      // Test creation with unit set to HbarUnit.tinybar.
      final hbar1 = Hbar(50, HbarUnit.tinybar);
      expect(hbar1.toTinybars(), 50);
      expect(hbar1.toHbars(), 0.0000005);
    });

    test('testConstructorWithUnit', () {
      // Test creation directly in tinybars.
      final hbar1 = Hbar(50, HbarUnit.tinybar);
      expect(hbar1.toTinybars(), 50);
      expect(hbar1.toHbars(), 0.0000005);

      final hbar2 = Hbar(50, HbarUnit.microbar);
      expect(hbar2.toTinybars(), 5000);
      expect(hbar2.toHbars(), 0.00005);

      final hbar3 = Hbar(50, HbarUnit.millibar);
      expect(hbar3.toTinybars(), 5000000);
      expect(hbar3.toHbars(), 0.05);

      final hbar4 = Hbar(50, HbarUnit.hbar);
      expect(hbar4.toTinybars(), 5000000000);
      expect(hbar4.toHbars(), 50.0);

      final hbar5 = Hbar(50, HbarUnit.kilobar);
      expect(hbar5.toTinybars(), 5000000000000);
      expect(hbar5.toHbars(), 50000.0);

      final hbar6 = Hbar(50, HbarUnit.megabar);
      expect(hbar6.toTinybars(), 5000000000000000);
      expect(hbar6.toHbars(), 50000000.0);

      final hbar7 = Hbar(50, HbarUnit.gigabar);
      expect(hbar7.toTinybars(), 5000000000000000000);
      expect(hbar7.toHbars(), 50000000000.0);
    });

    test('testConstructorFractionalTinybar', () {
      // Test creation with fractional tinybars.
      expect(
        () => Hbar(0.1, HbarUnit.tinybar),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Fractional tinybar value not allowed'),
          ),
        ),
      );
    });

    test('testConstructorFractionalNonTinybarAmount', () {
      // Test creation rejects values that do not map to an integral tinybar amount.
      expect(
        () => Hbar(Decimal.parse('0.000000001'), HbarUnit.hbar),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Fractional tinybar value not allowed'),
          ),
        ),
      );
    });

    test('testFromString', () {
      // Test creation of HBAR from valid string
      expect(Hbar.fromString('1').toTinybars(), 100000000);
      expect(Hbar.fromString('1 ℏ').toTinybars(), 100000000);
      expect(Hbar.fromString('1.5 mℏ').toTinybars(), 150000);
      expect(Hbar.fromString('+1.5 mℏ').toTinybars(), 150000);
      expect(Hbar.fromString('-1.5 mℏ').toTinybars(), -150000);
      expect(Hbar.fromString('+3').toTinybars(), 300000000);
      expect(Hbar.fromString('-3').toTinybars(), -300000000);
    });

    test('testToTinybarsPreservesLargeIntegerValues', () {
      // toTinybars() should not lose precision for integers above float-safe range.
      final tinybars = 9007199254740993; // 2^53 + 1
      final hbar = Hbar.fromTinybars(tinybars);
      expect(hbar.toTinybars(), tinybars);
    });

    test('testFromStringPreservesLargeIntegerHbarValues', () {
      // Parsing large whole hbar values should preserve the exact tinybar amount.
      final hbarAmount = '90071992.54740993';
      final expectedTinybars = 9007199254740993;
      expect(Hbar.fromString(hbarAmount).toTinybars(), expectedTinybars);
    });

    test('testFromStringInvalid', () {
      final invalidStrings = [
        '1 ',
        '-1 ',
        '+1 ',
        '1.151 ',
        '-1.151 ',
        '+1.151 ',
        '1.',
        '1.151.',
        '.1',
        '1.151 uℏ',
        '1.151 h',
        'abcd',
      ];

      for (final invalidStr in invalidStrings) {
        expect(
          () => Hbar.fromString(invalidStr),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('Invalid Hbar format: $invalidStr'),
            ),
          ),
        );
      }
    });

    test('testCreationUsingOfMethod', () {
      // Test creation of HBAR using of method
      expect(Hbar.of(50, HbarUnit.tinybar).toTinybars(), 50);
      expect(Hbar.of(50, HbarUnit.hbar).toTinybars(), 5000000000);
      expect(Hbar.of(50, HbarUnit.microbar).toTinybars(), 5000);
      expect(Hbar.of(50, HbarUnit.millibar).toTinybars(), 5000000);
      expect(Hbar.of(50, HbarUnit.kilobar).toTinybars(), 5000000000000);
      expect(Hbar.of(50, HbarUnit.megabar).toTinybars(), 5000000000000000);
      expect(Hbar.of(50, HbarUnit.gigabar).toTinybars(), 5000000000000000000);
    });

    test('testToUnit', () {
      expect(Hbar(50).to(HbarUnit.hbar), 50.0);
      expect(Hbar(50).to(HbarUnit.tinybar), 5000000000.0);
      expect(Hbar(50).to(HbarUnit.microbar), 50000000.0);
      expect(Hbar(50).to(HbarUnit.millibar), 50000.0);
      expect(Hbar(50).to(HbarUnit.kilobar), 0.05);
      expect(Hbar(50).to(HbarUnit.megabar), 0.00005);
      expect(Hbar(50).to(HbarUnit.gigabar), 0.00000005);
    });

    test('testNegated', () {
      // Test negation of Hbar values.
      final hbar = Hbar(10);
      final negHbar = hbar.negated();
      expect(negHbar.toTinybars(), -1000000000);
      expect(negHbar.negated(), hbar);
    });

    test('testHbarConstant', () {
      expect(Hbar.zero.toHbars(), 0.0);
      expect(Hbar.max.toHbars(), 50000000000.0);
      expect(Hbar.min.toHbars(), -50000000000.0);
    });

    test('testComparison', () {
      // Test comparison and equality operators.
      final h1 = Hbar(1);
      final h2 = Hbar(2);
      final h3 = Hbar(1);

      expect(h1 == h3, isTrue);
      expect(h1 != h2, isTrue);
      expect(h1 < h2, isTrue);
      expect(h2 > h1, isTrue);
      expect(h1 <= h3, isTrue);
      expect(h2 >= h1, isTrue);
    });

    test('testFactoryMethods', () {
      // Test the convenient from_X factory methods.
      // fromMicrobars
      var result = Hbar.fromMicrobars(1);
      expect(result.toTinybars(), 100);
      expect(Hbar.fromMicrobars(1.5).toTinybars(), 150);
      expect(Hbar.fromMicrobars(Decimal.parse('2.5')).toTinybars(), 250);
      expect(Hbar.fromMicrobars(0).toTinybars(), 0);
      expect(Hbar.fromMicrobars(-10).toTinybars(), -1000);
      expect(result, Hbar(1, HbarUnit.microbar));

      // fromMillibars
      expect(Hbar.fromMillibars(1).toTinybars(), 100000);
      expect(Hbar.fromMillibars(0).toTinybars(), 0);
      expect(Hbar.fromMillibars(-5).toTinybars(), -500000);
      expect(Hbar.fromMillibars(Decimal.parse('1.5')).toTinybars(), 150000);

      // fromHbars
      expect(Hbar.fromHbars(1).toTinybars(), 100000000);
      expect(Hbar.fromHbars(0.00000001).toTinybars(), 1);
      expect(Hbar.fromHbars(0).toTinybars(), 0);
      expect(Hbar.fromHbars(-10).toTinybars(), -1000000000);
      expect(Hbar.fromHbars(Decimal.parse('5.5')).toTinybars(), 550000000);

      // fromKilobars
      expect(Hbar.fromKilobars(1).toHbars(), 1000.0);
      expect(Hbar.fromKilobars(0).toHbars(), 0.0);
      expect(Hbar.fromKilobars(-2).toHbars(), -2000.0);
      expect(Hbar.fromKilobars(1).toTinybars(), 100000000000);

      // fromMegabars
      expect(Hbar.fromMegabars(1).toHbars(), 1000000.0);
      expect(Hbar.fromMegabars(0).toHbars(), 0.0);
      expect(Hbar.fromMegabars(-1).toHbars(), -1000000.0);
      expect(Hbar.fromMegabars(1).toTinybars(), 100000000000000);

      // fromGigabars
      expect(Hbar.fromGigabars(1).toHbars(), 1000000000.0);
      expect(Hbar.fromGigabars(0).toHbars(), 0.0);
      expect(Hbar.fromGigabars(-1).toHbars(), -1000000000.0);
      expect(Hbar.fromGigabars(1).toTinybars(), 100000000000000000);
    });

    test('testStrFormattingAndNegatives', () {
      // String representation should use fixed 8 decimal places.
      expect(Hbar(1).toString(), '1.00000000 ℏ');
      expect(Hbar(-1).toString(), '-1.00000000 ℏ');
    });

    test('testToDebugString', () {
      // toDebugString() should include class name and value.
      final h = Hbar(2);
      final r = h.toDebugString();
      expect(r, startsWith('Hbar('));
      expect(r, contains('2.00000000'));
    });

    test('testFromTinybars', () {
      final h = Hbar.fromTinybars(100);
      expect(h.toTinybars(), 100);
    });

    test('testHashConsistencyForEqualValues', () {
      // Equal Hbar values must have identical hashes.
      final h1 = Hbar(1);
      final h2 = Hbar(1);

      expect(h1, equals(h2));
      expect(h1.hashCode, equals(h2.hashCode));

      final values = {h1, h2};
      expect(values.length, 1);

      final d = {h1: 'value1'};
      d[h2] = 'value2';
      expect(d.length, 1);
      expect(d[h1], 'value2');
    });
  });
}
