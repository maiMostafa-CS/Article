import 'package:flutter_test/flutter_test.dart';
import 'package:inc_project/core/error/exceptions.dart';

void main() {
  group('Exceptions', () {
    group('ServerException', () {
      test('should be a subclass of Exception', () {
        // Arrange & Act
        const exception = ServerException('ServerException');

        // Assert
        expect(exception, isA<Exception>());
      });

      test('should have correct message for equality comparison', () {
        // Arrange
        const exception1 = ServerException('ServerException');
        const exception2 = ServerException('ServerException');

        // Act & Assert
        expect(exception1.message, exception2.message);
        expect(exception1, equals(exception2));
      });

      test('should have empty message list', () {
        // Arrange
        const exception = ServerException('ServerException');

        // Act & Assert
        expect(exception.message, isEmpty);
      });

      test('should maintain equality across different instances', () {
        // Arrange
        const exception1 = ServerException('ServerException');
        const exception2 = ServerException('ServerException');
        const exception3 = ServerException('ServerException');

        // Act & Assert
        expect(exception1, equals(exception2));
        expect(exception2, equals(exception3));
        expect(exception1, equals(exception3));
        expect(exception1.hashCode, equals(exception2.hashCode));
      });

      test('should have consistent string representation', () {
        // Arrange
        const exception = ServerException('ServerException');

        // Act
        final stringRepresentation = exception.toString();

        // Assert
        expect(stringRepresentation, contains('ServerException'));
        expect(stringRepresentation, isA<String>());
        expect(stringRepresentation, isNotEmpty);
      });

      test('should be different from other exception types', () {
        // Arrange
        const serverException = ServerException('ServerException');
        const cacheException = CacheException('CacheException');
        const networkException = NetworkException('NetworkException');

        // Act & Assert
        expect(serverException, isNot(equals(cacheException)));
        expect(serverException, isNot(equals(networkException)));
        expect(
          serverException.hashCode,
          isNot(equals(cacheException.hashCode)),
        );
        expect(
          serverException.hashCode,
          isNot(equals(networkException.hashCode)),
        );
      });

      test('should be throwable', () {
        // Arrange
        const exception = ServerException('ServerException');

        // Act & Assert
        expect(() => throw exception, throwsA(isA<ServerException>()));
        expect(() => throw exception, throwsA(isA<Exception>()));
      });

      test('should work in try-catch blocks', () {
        // Arrange
        const exception = ServerException('ServerException');
        var caughtException;

        // Act
        try {
          throw exception;
        } catch (e) {
          caughtException = e;
        }

        // Assert
        expect(caughtException, isA<ServerException>());
        expect(caughtException, equals(exception));
      });
    });

    group('CacheException', () {
      test('should be a subclass of Exception', () {
        // Arrange & Act
        const exception = CacheException('CacheException');

        // Assert
        expect(exception, isA<Exception>());
      });

      test('should have correct message for equality comparison', () {
        // Arrange
        const exception1 = CacheException('CacheException');
        const exception2 = CacheException('CacheException');

        // Act & Assert
        expect(exception1.message, exception2.message);
        expect(exception1, equals(exception2));
      });

      test('should have empty message list', () {
        // Arrange
        const exception = CacheException('CacheException');

        // Act & Assert
        expect(exception.message, isEmpty);
      });

      test('should maintain equality across different instances', () {
        // Arrange
        const exception1 = CacheException('CacheException');
        const exception2 = CacheException('CacheException');
        const exception3 = CacheException('CacheException');

        // Act & Assert
        expect(exception1, equals(exception2));
        expect(exception2, equals(exception3));
        expect(exception1, equals(exception3));
        expect(exception1.hashCode, equals(exception2.hashCode));
      });

      test('should have consistent string representation', () {
        // Arrange
        const exception = CacheException('CacheException');

        // Act
        final stringRepresentation = exception.toString();

        // Assert
        expect(stringRepresentation, contains('CacheException'));
        expect(stringRepresentation, isA<String>());
        expect(stringRepresentation, isNotEmpty);
      });

      test('should be different from other exception types', () {
        // Arrange
        const cacheException = CacheException('CacheException');
        const serverException = ServerException('ServerException');
        const networkException = NetworkException('NetworkException');

        // Act & Assert
        expect(cacheException, isNot(equals(serverException)));
        expect(cacheException, isNot(equals(networkException)));
        expect(
          cacheException.hashCode,
          isNot(equals(serverException.hashCode)),
        );
        expect(
          cacheException.hashCode,
          isNot(equals(networkException.hashCode)),
        );
      });

      test('should be throwable', () {
        // Arrange
        const exception = CacheException('CacheException');

        // Act & Assert
        expect(() => throw exception, throwsA(isA<CacheException>()));
        expect(() => throw exception, throwsA(isA<Exception>()));
      });

      test('should work in try-catch blocks', () {
        // Arrange
        const exception = CacheException('CacheException');
        var caughtException;

        // Act
        try {
          throw exception;
        } catch (e) {
          caughtException = e;
        }

        // Assert
        expect(caughtException, isA<CacheException>());
        expect(caughtException, equals(exception));
      });
    });

    group('NetworkException', () {
      test('should be a subclass of Exception', () {
        // Arrange & Act
        const exception = NetworkException('NetworkException');

        // Assert
        expect(exception, isA<Exception>());
      });

      test('should have correct message for equality comparison', () {
        // Arrange
        const exception1 = NetworkException('NetworkException');
        const exception2 = NetworkException('NetworkException');

        // Act & Assert
        expect(exception1.message, exception2.message);
        expect(exception1, equals(exception2));
      });

      test('should have empty message list', () {
        // Arrange
        const exception = NetworkException('NetworkException');

        // Act & Assert
        expect(exception.message, isEmpty);
      });

      test('should maintain equality across different instances', () {
        // Arrange
        const exception1 = NetworkException('NetworkException');
        const exception2 = NetworkException('NetworkException');
        const exception3 = NetworkException('NetworkException');

        // Act & Assert
        expect(exception1, equals(exception2));
        expect(exception2, equals(exception3));
        expect(exception1, equals(exception3));
        expect(exception1.hashCode, equals(exception2.hashCode));
      });

      test('should have consistent string representation', () {
        // Arrange
        const exception = NetworkException('NetworkException');

        // Act
        final stringRepresentation = exception.toString();

        // Assert
        expect(stringRepresentation, contains('NetworkException'));
        expect(stringRepresentation, isA<String>());
        expect(stringRepresentation, isNotEmpty);
      });

      test('should be different from other exception types', () {
        // Arrange
        const networkException = NetworkException('NetworkException');
        const serverException = ServerException('ServerException');
        const cacheException = CacheException('CacheException');

        // Act & Assert
        expect(networkException, isNot(equals(serverException)));
        expect(networkException, isNot(equals(cacheException)));
        expect(
          networkException.hashCode,
          isNot(equals(serverException.hashCode)),
        );
        expect(
          networkException.hashCode,
          isNot(equals(cacheException.hashCode)),
        );
      });

      test('should be throwable', () {
        // Arrange
        const exception = NetworkException('NetworkException');

        // Act & Assert
        expect(() => throw exception, throwsA(isA<NetworkException>()));
        expect(() => throw exception, throwsA(isA<Exception>()));
      });

      test('should work in try-catch blocks', () {
        // Arrange
        const exception = NetworkException('NetworkException');
        var caughtException;

        // Act
        try {
          throw exception;
        } catch (e) {
          caughtException = e;
        }

        // Assert
        expect(caughtException, isA<NetworkException>());
        expect(caughtException, equals(exception));
      });
    });

    group('Exception hierarchy', () {
      test('all exception types should extend Exception', () {
        // Arrange
        const serverException = ServerException('ServerException');
        const cacheException = CacheException('CacheException');
        const networkException = NetworkException('NetworkException');

        // Act & Assert
        expect(serverException, isA<Exception>());
        expect(cacheException, isA<Exception>());
        expect(networkException, isA<Exception>());
      });

      test('all exception types should be distinct', () {
        // Arrange
        const exceptions = [
          ServerException('ServerException'),
          CacheException('CacheException'),
          NetworkException('NetworkException'),
        ];

        // Act & Assert
        for (int i = 0; i < exceptions.length; i++) {
          for (int j = i + 1; j < exceptions.length; j++) {
            expect(
              exceptions[i],
              isNot(equals(exceptions[j])),
              reason:
                  'Exception at index $i should not equal exception at index $j',
            );
            expect(
              exceptions[i].runtimeType,
              isNot(equals(exceptions[j].runtimeType)),
              reason: 'Exception types should be different',
            );
          }
        }
      });

      test('exception types should have consistent behavior', () {
        // Arrange
        const exceptions = [
          ServerException('ServerException'),
          CacheException('CacheException'),
          NetworkException('NetworkException'),
        ];

        // Act & Assert
        for (final exception in exceptions) {
          expect(exception, isA<List>());
          expect(exception.toString(), isA<String>());
          expect(exception.toString(), isNotEmpty);
          expect(exception.hashCode, isA<int>());
        }
      });

      test('should support pattern matching by type', () {
        // Arrange
        const exceptions = [
          ServerException('ServerException'),
          CacheException('CacheException'),
          NetworkException('NetworkException'),
        ];

        // Act & Assert
        for (final exception in exceptions) {
          switch (exception.runtimeType) {
            case ServerException:
              expect(exception, isA<ServerException>());
              break;
            case CacheException:
              expect(exception, isA<CacheException>());
              break;
            case NetworkException:
              expect(exception, isA<NetworkException>());
              break;
            default:
              fail('Unexpected exception type: ${exception.runtimeType}');
          }
        }
      });

      test('should work correctly in collections', () {
        // Arrange
        const exceptions = [
          ServerException('ServerException'),
          CacheException('CacheException'),
          NetworkException('NetworkException'),
          ServerException('ServerException'), // Duplicate
        ];

        // Act
        final exceptionSet = exceptions.toSet();
        final serverExceptions = exceptions
            .whereType<ServerException>()
            .toList();
        final cacheExceptions = exceptions.whereType<CacheException>().toList();
        final networkExceptions = exceptions
            .whereType<NetworkException>()
            .toList();

        // Assert
        expect(exceptionSet.length, 3); // Duplicates removed
        expect(serverExceptions.length, 2); // Two ServerException instances
        expect(cacheExceptions.length, 1);
        expect(networkExceptions.length, 1);
      });

      test('should maintain immutability', () {
        // Arrange
        const exception1 = ServerException('ServerException');
        const exception2 = ServerException('ServerException');

        // Act & Assert
        expect(exception1.message, equals(exception2.message));
        expect(exception1, equals(exception2));

        // Verify that message cannot be modified (they should be immutable)
        expect(() => exception1.message, throwsUnsupportedError);
      });

      test('should work with async operations', () async {
        // Arrange
        Future<void> throwServerException() async {
          await Future.delayed(Duration(milliseconds: 1));
          throw const ServerException('ServerException');
        }

        Future<void> throwCacheException() async {
          await Future.delayed(Duration(milliseconds: 1));
          throw const CacheException('CacheException');
        }

        // Act & Assert
        expect(() => throwServerException(), throwsA(isA<ServerException>()));
        expect(() => throwCacheException(), throwsA(isA<CacheException>()));
      });

      test('should work in nested try-catch blocks', () {
        // Arrange
        const serverException = ServerException('ServerException');
        const cacheException = CacheException('CacheException');
        var outerCaughtException;
        var innerCaughtException;

        // Act
        try {
          try {
            throw serverException;
          } catch (e) {
            innerCaughtException = e;
            throw cacheException;
          }
        } catch (e) {
          outerCaughtException = e;
        }

        // Assert
        expect(innerCaughtException, isA<ServerException>());
        expect(outerCaughtException, isA<CacheException>());
        expect(innerCaughtException, equals(serverException));
        expect(outerCaughtException, equals(cacheException));
      });

      test('should work with specific exception catching', () {
        // Arrange
        const exceptions = [
          ServerException('ServerException'),
          CacheException('CacheException'),
          NetworkException('NetworkException'),
        ];
        final caughtExceptions = <Exception>[];

        // Act
        for (final exception in exceptions) {
          try {
            throw exception;
          } on ServerException catch (e) {
            caughtExceptions.add(e);
          } on CacheException catch (e) {
            caughtExceptions.add(e);
          } on NetworkException catch (e) {
            caughtExceptions.add(e);
          }
        }

        // Assert
        expect(caughtExceptions.length, 3);
        expect(caughtExceptions[0], isA<ServerException>());
        expect(caughtExceptions[1], isA<CacheException>());
        expect(caughtExceptions[2], isA<NetworkException>());
      });
    });
  });
}
