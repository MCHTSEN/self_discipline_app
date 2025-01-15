// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'identify_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$IdentifyState {
  int get currentPageIndex => throw _privateConstructorUsedError;
  List<List<bool>> get selectedAnswers => throw _privateConstructorUsedError;
  List<UserIdentifyModel> get pages => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $IdentifyStateCopyWith<IdentifyState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IdentifyStateCopyWith<$Res> {
  factory $IdentifyStateCopyWith(
          IdentifyState value, $Res Function(IdentifyState) then) =
      _$IdentifyStateCopyWithImpl<$Res, IdentifyState>;
  @useResult
  $Res call(
      {int currentPageIndex,
      List<List<bool>> selectedAnswers,
      List<UserIdentifyModel> pages});
}

/// @nodoc
class _$IdentifyStateCopyWithImpl<$Res, $Val extends IdentifyState>
    implements $IdentifyStateCopyWith<$Res> {
  _$IdentifyStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPageIndex = null,
    Object? selectedAnswers = null,
    Object? pages = null,
  }) {
    return _then(_value.copyWith(
      currentPageIndex: null == currentPageIndex
          ? _value.currentPageIndex
          : currentPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      selectedAnswers: null == selectedAnswers
          ? _value.selectedAnswers
          : selectedAnswers // ignore: cast_nullable_to_non_nullable
              as List<List<bool>>,
      pages: null == pages
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<UserIdentifyModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IdentifyStateImplCopyWith<$Res>
    implements $IdentifyStateCopyWith<$Res> {
  factory _$$IdentifyStateImplCopyWith(
          _$IdentifyStateImpl value, $Res Function(_$IdentifyStateImpl) then) =
      __$$IdentifyStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentPageIndex,
      List<List<bool>> selectedAnswers,
      List<UserIdentifyModel> pages});
}

/// @nodoc
class __$$IdentifyStateImplCopyWithImpl<$Res>
    extends _$IdentifyStateCopyWithImpl<$Res, _$IdentifyStateImpl>
    implements _$$IdentifyStateImplCopyWith<$Res> {
  __$$IdentifyStateImplCopyWithImpl(
      _$IdentifyStateImpl _value, $Res Function(_$IdentifyStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPageIndex = null,
    Object? selectedAnswers = null,
    Object? pages = null,
  }) {
    return _then(_$IdentifyStateImpl(
      currentPageIndex: null == currentPageIndex
          ? _value.currentPageIndex
          : currentPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      selectedAnswers: null == selectedAnswers
          ? _value._selectedAnswers
          : selectedAnswers // ignore: cast_nullable_to_non_nullable
              as List<List<bool>>,
      pages: null == pages
          ? _value._pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<UserIdentifyModel>,
    ));
  }
}

/// @nodoc

class _$IdentifyStateImpl implements _IdentifyState {
  const _$IdentifyStateImpl(
      {required this.currentPageIndex,
      required final List<List<bool>> selectedAnswers,
      required final List<UserIdentifyModel> pages})
      : _selectedAnswers = selectedAnswers,
        _pages = pages;

  @override
  final int currentPageIndex;
  final List<List<bool>> _selectedAnswers;
  @override
  List<List<bool>> get selectedAnswers {
    if (_selectedAnswers is EqualUnmodifiableListView) return _selectedAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedAnswers);
  }

  final List<UserIdentifyModel> _pages;
  @override
  List<UserIdentifyModel> get pages {
    if (_pages is EqualUnmodifiableListView) return _pages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pages);
  }

  @override
  String toString() {
    return 'IdentifyState(currentPageIndex: $currentPageIndex, selectedAnswers: $selectedAnswers, pages: $pages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IdentifyStateImpl &&
            (identical(other.currentPageIndex, currentPageIndex) ||
                other.currentPageIndex == currentPageIndex) &&
            const DeepCollectionEquality()
                .equals(other._selectedAnswers, _selectedAnswers) &&
            const DeepCollectionEquality().equals(other._pages, _pages));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentPageIndex,
      const DeepCollectionEquality().hash(_selectedAnswers),
      const DeepCollectionEquality().hash(_pages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IdentifyStateImplCopyWith<_$IdentifyStateImpl> get copyWith =>
      __$$IdentifyStateImplCopyWithImpl<_$IdentifyStateImpl>(this, _$identity);
}

abstract class _IdentifyState implements IdentifyState {
  const factory _IdentifyState(
      {required final int currentPageIndex,
      required final List<List<bool>> selectedAnswers,
      required final List<UserIdentifyModel> pages}) = _$IdentifyStateImpl;

  @override
  int get currentPageIndex;
  @override
  List<List<bool>> get selectedAnswers;
  @override
  List<UserIdentifyModel> get pages;
  @override
  @JsonKey(ignore: true)
  _$$IdentifyStateImplCopyWith<_$IdentifyStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
