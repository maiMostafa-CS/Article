import 'package:flutter_test/flutter_test.dart';
import 'package:inc_project/core/error/failures.dart';

void main() {
  group('Failure', () {
    group('ServerFailure', () {
      test('should be a subclass of Failure', () {
        // Arrange & Act
        const failure = ServerFailure('ServerFailure');

        // Assert
        expect(failure, isA<Failure>());
      });

      test('should have correct props for equality comparison', () {
        // Arrange
        const failure1 = ServerFailure('ServerFailure');
        const failure2 = ServerFailure('ServerFailure');

        // Act & Assert
        expect(failure1.props, failure2.props);
        expect(failure1, equals(failure2));
      });

      test('should have empty props list', () {
        // Arrange
        const failure = ServerFailure('ServerFailure');

        // Act & Assert
        expect(failure.props, isEmpty);
      });

      test('should maintain equality across different instances', () {
        // Arrange
        const failure1 = ServerFailure('ServerFailure');
        const failure2 = ServerFailure('ServerFailure');
        const failure3 = ServerFailure('ServerFailure');

        // Act & Assert
        expect(failure1, equals(failure2));
        expect(failure2, equals(failure3));
        expect(failure1, equals(failure3));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });

      test('should have consistent string representation', () {
        // Arrange
        const failure = ServerFailure('ServerFailure');

        // Act
        final stringRepresentation = failure.toString();

        // Assert
        expect(stringRepresentation, contains('ServerFailure'));
        expect(stringRepresentation, isA<String>());
        expect(stringRepresentation, isNotEmpty);
      });

      test('should be different from other failure types', () {
        // Arrange
        const serverFailure = ServerFailure('ServerFailure');
        const cacheFailure = CacheFailure('CacheFailure');
        const networkFailure = NetworkFailure('NetworkFailure');

        // Act & Assert
        expect(serverFailure, isNot(equals(cacheFailure)));
        expect(serverFailure, isNot(equals(networkFailure)));
        expect(serverFailure.hashCode, isNot(equals(cacheFailure.hashCode)));
        expect(serverFailure.hashCode, isNot(equals(networkFailure.hashCode)));
      });
    });

    group('CacheFailure', () {
      test('should be a subclass of Failure', () {
        // Arrange & Act
        const failure = CacheFailure('CacheFailure');

        // Assert
        expect(failure, isA<Failure>());
      });

      test('should have correct props for equality comparison', () {
        // Arrange
        const failure1 = CacheFailure('CacheFailure');
        const failure2 = CacheFailure('CacheFailure');

        // Act & Assert
        expect(failure1.props, failure2.props);
        expect(failure1, equals(failure2));
      });

      test('should have empty props list', () {
        // Arrange
        const failure = CacheFailure('CacheFailure');

        // Act & Assert
        expect(failure.props, isEmpty);
      });

      test('should maintain equality across different instances', () {
        // Arrange
        const failure1 = CacheFailure('CacheFailure');
        const failure2 = CacheFailure('CacheFailure');
        const failure3 = CacheFailure('CacheFailure');

        // Act & Assert
        expect(failure1, equals(failure2));
        expect(failure2, equals(failure3));
        expect(failure1, equals(failure3));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });

      test('should have consistent string representation', () {
        // Arrange
        const failure = CacheFailure('CacheFailure');

        // Act
        final stringRepresentation = failure.toString();

        // Assert
        expect(stringRepresentation, contains('CacheFailure'));
        expect(stringRepresentation, isA<String>());
        expect(stringRepresentation, isNotEmpty);
      });

      test('should be different from other failure types', () {
        // Arrange
        const cacheFailure = CacheFailure('CacheFailure');
        const serverFailure = ServerFailure('ServerFailure');
        const networkFailure = NetworkFailure('NetworkFailure');

        // Act & Assert
        expect(cacheFailure, isNot(equals(serverFailure)));
        expect(cacheFailure, isNot(equals(networkFailure)));
        expect(cacheFailure.hashCode, isNot(equals(serverFailure.hashCode)));
        expect(cacheFailure.hashCode, isNot(equals(networkFailure.hashCode)));
      });
    });

    group('NetworkFailure', () {
      test('should be a subclass of Failure', () {
        // Arrange & Act
        const failure = NetworkFailure('NetworkFailure');

        // Assert
        expect(failure, isA<Failure>());
      });

      test('should have correct props for equality comparison', () {
        // Arrange
        const failure1 = NetworkFailure('NetworkFailure');
        const failure2 = NetworkFailure('NetworkFailure');

        // Act & Assert
        expect(failure1.props, failure2.props);
        expect(failure1, equals(failure2));
      });

      test('should have empty props list', () {
        // Arrange
        const failure = NetworkFailure('NetworkFailure');

        // Act & Assert
        expect(failure.props, isEmpty);
      });

      test('should maintain equality across different instances', () {
        // Arrange
        const failure1 = NetworkFailure('NetworkFailure');
        const failure2 = NetworkFailure('NetworkFailure');
        const failure3 = NetworkFailure('NetworkFailure');

        // Act & Assert
        expect(failure1, equals(failure2));
        expect(failure2, equals(failure3));
        expect(failure1, equals(failure3));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });

      test('should have consistent string representation', () {
        // Arrange
        const failure = NetworkFailure('NetworkFailure');

        // Act
        final stringRepresentation = failure.toString();

        // Assert
        expect(stringRepresentation, contains('NetworkFailure'));
        expect(stringRepresentation, isA<String>());
        expect(stringRepresentation, isNotEmpty);
      });

      test('should be different from other failure types', () {
        // Arrange
        const networkFailure = NetworkFailure('NetworkFailure');
        const serverFailure = ServerFailure('ServerFailure');
        const cacheFailure = CacheFailure('CacheFailure');

        // Act & Assert
        expect(networkFailure, isNot(equals(serverFailure)));
        expect(networkFailure, isNot(equals(cacheFailure)));
        expect(networkFailure.hashCode, isNot(equals(serverFailure.hashCode)));
        expect(networkFailure.hashCode, isNot(equals(cacheFailure.hashCode)));
      });
    });

    group('Failure hierarchy', () {
      test('all failure types should extend Failure', () {
        // Arrange
        const serverFailure = ServerFailure('ServerFailure');
        const cacheFailure = CacheFailure('CacheFailure');
        const networkFailure = NetworkFailure('NetworkFailure');

        // Act & Assert
        expect(serverFailure, isA<Failure>());
        expect(cacheFailure, isA<Failure>());
        expect(networkFailure, isA<Failure>());
      });

      test('all failure types should be distinct', () {
        // Arrange
        const failures = [
          ServerFailure('ServerFailure'),
          CacheFailure('CacheFailure'),
          NetworkFailure('NetworkFailure'),
        ];

        // Act & Assert
        for (int i = 0; i < failures.length; i++) {
          for (int j = i + 1; j < failures.length; j++) {
            expect(
              failures[i],
              isNot(equals(failures[j])),
              reason:
                  'Failure at index $i should not equal failure at index $j',
            );
            expect(
              failures[i].runtimeType,
              isNot(equals(failures[j].runtimeType)),
              reason: 'Failure types should be different',
            );
          }
        }
      });

      test('failure types should have consistent behavior', () {
        // Arrange
        const failures = [
          ServerFailure('ServerFailure'),
          CacheFailure('CacheFailure'),
          NetworkFailure('NetworkFailure'),
        ];

        // Act & Assert
        for (final failure in failures) {
          expect(failure.props, isA<List>());
          expect(failure.toString(), isA<String>());
          expect(failure.toString(), isNotEmpty);
          expect(failure.hashCode, isA<int>());
        }
      });

      test('should support pattern matching by type', () {
        // Arrange
        const failures = [
          ServerFailure('ServerFailure'),
          CacheFailure('CacheFailure'),
          NetworkFailure('NetworkFailure'),
        ];

        // Act & Assert
        for (final failure in failures) {
          switch (failure.runtimeType) {
            case ServerFailure:
              expect(failure, isA<ServerFailure>());
              break;
            case CacheFailure:
              expect(failure, isA<CacheFailure>());
              break;
            case NetworkFailure:
              expect(failure, isA<NetworkFailure>());
              break;
            default:
              fail('Unexpected failure type: ${failure.runtimeType}');
          }
        }
      });

      test('should work correctly in collections', () {
        // Arrange
        const failures = [
          ServerFailure('ServerFailure'),
          CacheFailure('CacheFailure'),
          NetworkFailure('NetworkFailure'),
          ServerFailure('ServerFailure'), // Duplicate
        ];

        // Act
        final failureSet = failures.toSet();
        final serverFailures = failures.whereType<ServerFailure>().toList();
        final cacheFailures = failures.whereType<CacheFailure>().toList();
        final networkFailures = failures.whereType<NetworkFailure>().toList();

        // Assert
        expect(failureSet.length, 3); // Duplicates removed
        expect(serverFailures.length, 2); // Two ServerFailure instances
        expect(cacheFailures.length, 1);
        expect(networkFailures.length, 1);
      });

      test('should maintain immutability', () {
        // Arrange
        const failure1 = ServerFailure('ServerFailure');
        const failure2 = ServerFailure('ServerFailure');

        // Act & Assert
        expect(failure1.props, equals(failure2.props));
        expect(failure1, equals(failure2));

        // Verify that props cannot be modified (they should be immutable)
        expect(() => failure1.props.add('new_prop'), throwsUnsupportedError);
      });

      test('should work with async operations', () async {
        // Arrange
        Future<Failure> getServerFailure() async {
          await Future.delayed(Duration(milliseconds: 1));
          return const ServerFailure('ServerFailure');
        }

        Future<Failure> getCacheFailure() async {
          await Future.delayed(Duration(milliseconds: 1));
          return const CacheFailure('CacheFailure');
        }

        // Act
        final serverFailure = await getServerFailure();
        final cacheFailure = await getCacheFailure();

        // Assert
        expect(serverFailure, isA<ServerFailure>());
        expect(cacheFailure, isA<CacheFailure>());
        expect(serverFailure, isNot(equals(cacheFailure)));
      });
    });
  });
}
