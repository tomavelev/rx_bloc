// Mocks generated by Mockito 5.0.9 from annotations
// in test_app/test/feature_counter/blocs/counter_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:mockito/mockito.dart' as _i1;
import 'package:{{project_name}}/base/count_data_sources/count_data_source.dart' as _i2;
import 'package:{{project_name}}/base/models/count.dart' as _i3;
import 'package:{{project_name}}/base/repositories/counter_repository.dart' as _i4;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeCountDataSource extends _i1.Fake implements _i2.CountDataSource {}

class _FakeCount extends _i1.Fake implements _i3.Count {}

/// A class which mocks [CounterRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockCounterRepository extends _i1.Mock implements _i4.CounterRepository {
  MockCounterRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.CountDataSource get countDataSource =>
      (super.noSuchMethod(Invocation.getter(#countDataSource),
          returnValue: _FakeCountDataSource()) as _i2.CountDataSource);
  @override
  _i5.Future<_i3.Count> getCurrent() =>
      (super.noSuchMethod(Invocation.method(#getCurrent, []),
          returnValue: Future<_i3.Count>.value(_FakeCount()))
      as _i5.Future<_i3.Count>);
  @override
  _i5.Future<_i3.Count> increment() =>
      (super.noSuchMethod(Invocation.method(#increment, []),
          returnValue: Future<_i3.Count>.value(_FakeCount()))
      as _i5.Future<_i3.Count>);
  @override
  _i5.Future<_i3.Count> decrement() =>
      (super.noSuchMethod(Invocation.method(#decrement, []),
          returnValue: Future<_i3.Count>.value(_FakeCount()))
      as _i5.Future<_i3.Count>);
}
