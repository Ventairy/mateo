// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mateo_map_style_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MateoMapLibreStyleFilter {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MateoMapLibreStyleFilter);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MateoMapLibreStyleFilter()';
  }
}

/// @nodoc
class $MateoMapLibreStyleFilterCopyWith<$Res> {
  $MateoMapLibreStyleFilterCopyWith(
    MateoMapLibreStyleFilter _,
    $Res Function(MateoMapLibreStyleFilter) __,
  );
}

/// Adds pattern-matching-related methods to [MateoMapLibreStyleFilter].
extension MateoMapLibreStyleFilterPatterns on MateoMapLibreStyleFilter {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MateoMapLibreStyleEqualsFilter value)? equals,
    TResult Function(MateoMapLibreStyleGteFilter value)? greaterThanOrEqual,
    TResult Function(MateoMapLibreStyleLteFilter value)? lessThanOrEqual,
    TResult Function(MateoMapLibreStyleAnyFilter value)? any,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapLibreStyleEqualsFilter() when equals != null:
        return equals(_that);
      case MateoMapLibreStyleGteFilter() when greaterThanOrEqual != null:
        return greaterThanOrEqual(_that);
      case MateoMapLibreStyleLteFilter() when lessThanOrEqual != null:
        return lessThanOrEqual(_that);
      case MateoMapLibreStyleAnyFilter() when any != null:
        return any(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MateoMapLibreStyleEqualsFilter value) equals,
    required TResult Function(MateoMapLibreStyleGteFilter value)
    greaterThanOrEqual,
    required TResult Function(MateoMapLibreStyleLteFilter value)
    lessThanOrEqual,
    required TResult Function(MateoMapLibreStyleAnyFilter value) any,
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapLibreStyleEqualsFilter():
        return equals(_that);
      case MateoMapLibreStyleGteFilter():
        return greaterThanOrEqual(_that);
      case MateoMapLibreStyleLteFilter():
        return lessThanOrEqual(_that);
      case MateoMapLibreStyleAnyFilter():
        return any(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MateoMapLibreStyleEqualsFilter value)? equals,
    TResult? Function(MateoMapLibreStyleGteFilter value)? greaterThanOrEqual,
    TResult? Function(MateoMapLibreStyleLteFilter value)? lessThanOrEqual,
    TResult? Function(MateoMapLibreStyleAnyFilter value)? any,
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapLibreStyleEqualsFilter() when equals != null:
        return equals(_that);
      case MateoMapLibreStyleGteFilter() when greaterThanOrEqual != null:
        return greaterThanOrEqual(_that);
      case MateoMapLibreStyleLteFilter() when lessThanOrEqual != null:
        return lessThanOrEqual(_that);
      case MateoMapLibreStyleAnyFilter() when any != null:
        return any(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String key, Object value)? equals,
    TResult Function(String key, num value)? greaterThanOrEqual,
    TResult Function(String key, num value)? lessThanOrEqual,
    TResult Function(List<MateoMapLibreStyleFilter> filters)? any,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapLibreStyleEqualsFilter() when equals != null:
        return equals(_that.key, _that.value);
      case MateoMapLibreStyleGteFilter() when greaterThanOrEqual != null:
        return greaterThanOrEqual(_that.key, _that.value);
      case MateoMapLibreStyleLteFilter() when lessThanOrEqual != null:
        return lessThanOrEqual(_that.key, _that.value);
      case MateoMapLibreStyleAnyFilter() when any != null:
        return any(_that.filters);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String key, Object value) equals,
    required TResult Function(String key, num value) greaterThanOrEqual,
    required TResult Function(String key, num value) lessThanOrEqual,
    required TResult Function(List<MateoMapLibreStyleFilter> filters) any,
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapLibreStyleEqualsFilter():
        return equals(_that.key, _that.value);
      case MateoMapLibreStyleGteFilter():
        return greaterThanOrEqual(_that.key, _that.value);
      case MateoMapLibreStyleLteFilter():
        return lessThanOrEqual(_that.key, _that.value);
      case MateoMapLibreStyleAnyFilter():
        return any(_that.filters);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String key, Object value)? equals,
    TResult? Function(String key, num value)? greaterThanOrEqual,
    TResult? Function(String key, num value)? lessThanOrEqual,
    TResult? Function(List<MateoMapLibreStyleFilter> filters)? any,
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapLibreStyleEqualsFilter() when equals != null:
        return equals(_that.key, _that.value);
      case MateoMapLibreStyleGteFilter() when greaterThanOrEqual != null:
        return greaterThanOrEqual(_that.key, _that.value);
      case MateoMapLibreStyleLteFilter() when lessThanOrEqual != null:
        return lessThanOrEqual(_that.key, _that.value);
      case MateoMapLibreStyleAnyFilter() when any != null:
        return any(_that.filters);
      case _:
        return null;
    }
  }
}

/// @nodoc

class MateoMapLibreStyleEqualsFilter implements MateoMapLibreStyleFilter {
  const MateoMapLibreStyleEqualsFilter({
    required this.key,
    required this.value,
  });

  final String key;
  final Object value;

  /// Create a copy of MateoMapLibreStyleFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleEqualsFilterCopyWith<MateoMapLibreStyleEqualsFilter>
  get copyWith =>
      _$MateoMapLibreStyleEqualsFilterCopyWithImpl<
        MateoMapLibreStyleEqualsFilter
      >(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyleEqualsFilter &&
            (identical(other.key, key) || other.key == key) &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, key, const DeepCollectionEquality().hash(value));

  @override
  String toString() {
    return 'MateoMapLibreStyleFilter.equals(key: $key, value: $value)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleEqualsFilterCopyWith<$Res>
    implements $MateoMapLibreStyleFilterCopyWith<$Res> {
  factory $MateoMapLibreStyleEqualsFilterCopyWith(
    MateoMapLibreStyleEqualsFilter value,
    $Res Function(MateoMapLibreStyleEqualsFilter) _then,
  ) = _$MateoMapLibreStyleEqualsFilterCopyWithImpl;
  @useResult
  $Res call({String key, Object value});
}

/// @nodoc
class _$MateoMapLibreStyleEqualsFilterCopyWithImpl<$Res>
    implements $MateoMapLibreStyleEqualsFilterCopyWith<$Res> {
  _$MateoMapLibreStyleEqualsFilterCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyleEqualsFilter _self;
  final $Res Function(MateoMapLibreStyleEqualsFilter) _then;

  /// Create a copy of MateoMapLibreStyleFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({Object? key = null, Object? value = null}) {
    return _then(
      MateoMapLibreStyleEqualsFilter(
        key: null == key
            ? _self.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value ? _self.value : value,
      ),
    );
  }
}

/// @nodoc

class MateoMapLibreStyleGteFilter implements MateoMapLibreStyleFilter {
  const MateoMapLibreStyleGteFilter({required this.key, required this.value});

  final String key;
  final num value;

  /// Create a copy of MateoMapLibreStyleFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleGteFilterCopyWith<MateoMapLibreStyleGteFilter>
  get copyWith =>
      _$MateoMapLibreStyleGteFilterCopyWithImpl<MateoMapLibreStyleGteFilter>(
        this,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyleGteFilter &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key, value);

  @override
  String toString() {
    return 'MateoMapLibreStyleFilter.greaterThanOrEqual(key: $key, value: $value)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleGteFilterCopyWith<$Res>
    implements $MateoMapLibreStyleFilterCopyWith<$Res> {
  factory $MateoMapLibreStyleGteFilterCopyWith(
    MateoMapLibreStyleGteFilter value,
    $Res Function(MateoMapLibreStyleGteFilter) _then,
  ) = _$MateoMapLibreStyleGteFilterCopyWithImpl;
  @useResult
  $Res call({String key, num value});
}

/// @nodoc
class _$MateoMapLibreStyleGteFilterCopyWithImpl<$Res>
    implements $MateoMapLibreStyleGteFilterCopyWith<$Res> {
  _$MateoMapLibreStyleGteFilterCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyleGteFilter _self;
  final $Res Function(MateoMapLibreStyleGteFilter) _then;

  /// Create a copy of MateoMapLibreStyleFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({Object? key = null, Object? value = null}) {
    return _then(
      MateoMapLibreStyleGteFilter(
        key: null == key
            ? _self.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _self.value
            : value // ignore: cast_nullable_to_non_nullable
                  as num,
      ),
    );
  }
}

/// @nodoc

class MateoMapLibreStyleLteFilter implements MateoMapLibreStyleFilter {
  const MateoMapLibreStyleLteFilter({required this.key, required this.value});

  final String key;
  final num value;

  /// Create a copy of MateoMapLibreStyleFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleLteFilterCopyWith<MateoMapLibreStyleLteFilter>
  get copyWith =>
      _$MateoMapLibreStyleLteFilterCopyWithImpl<MateoMapLibreStyleLteFilter>(
        this,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyleLteFilter &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key, value);

  @override
  String toString() {
    return 'MateoMapLibreStyleFilter.lessThanOrEqual(key: $key, value: $value)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleLteFilterCopyWith<$Res>
    implements $MateoMapLibreStyleFilterCopyWith<$Res> {
  factory $MateoMapLibreStyleLteFilterCopyWith(
    MateoMapLibreStyleLteFilter value,
    $Res Function(MateoMapLibreStyleLteFilter) _then,
  ) = _$MateoMapLibreStyleLteFilterCopyWithImpl;
  @useResult
  $Res call({String key, num value});
}

/// @nodoc
class _$MateoMapLibreStyleLteFilterCopyWithImpl<$Res>
    implements $MateoMapLibreStyleLteFilterCopyWith<$Res> {
  _$MateoMapLibreStyleLteFilterCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyleLteFilter _self;
  final $Res Function(MateoMapLibreStyleLteFilter) _then;

  /// Create a copy of MateoMapLibreStyleFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({Object? key = null, Object? value = null}) {
    return _then(
      MateoMapLibreStyleLteFilter(
        key: null == key
            ? _self.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _self.value
            : value // ignore: cast_nullable_to_non_nullable
                  as num,
      ),
    );
  }
}

/// @nodoc

class MateoMapLibreStyleAnyFilter implements MateoMapLibreStyleFilter {
  const MateoMapLibreStyleAnyFilter({
    required final List<MateoMapLibreStyleFilter> filters,
  }) : _filters = filters;

  final List<MateoMapLibreStyleFilter> _filters;
  List<MateoMapLibreStyleFilter> get filters {
    if (_filters is EqualUnmodifiableListView) return _filters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filters);
  }

  /// Create a copy of MateoMapLibreStyleFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleAnyFilterCopyWith<MateoMapLibreStyleAnyFilter>
  get copyWith =>
      _$MateoMapLibreStyleAnyFilterCopyWithImpl<MateoMapLibreStyleAnyFilter>(
        this,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyleAnyFilter &&
            const DeepCollectionEquality().equals(other._filters, _filters));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_filters));

  @override
  String toString() {
    return 'MateoMapLibreStyleFilter.any(filters: $filters)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleAnyFilterCopyWith<$Res>
    implements $MateoMapLibreStyleFilterCopyWith<$Res> {
  factory $MateoMapLibreStyleAnyFilterCopyWith(
    MateoMapLibreStyleAnyFilter value,
    $Res Function(MateoMapLibreStyleAnyFilter) _then,
  ) = _$MateoMapLibreStyleAnyFilterCopyWithImpl;
  @useResult
  $Res call({List<MateoMapLibreStyleFilter> filters});
}

/// @nodoc
class _$MateoMapLibreStyleAnyFilterCopyWithImpl<$Res>
    implements $MateoMapLibreStyleAnyFilterCopyWith<$Res> {
  _$MateoMapLibreStyleAnyFilterCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyleAnyFilter _self;
  final $Res Function(MateoMapLibreStyleAnyFilter) _then;

  /// Create a copy of MateoMapLibreStyleFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({Object? filters = null}) {
    return _then(
      MateoMapLibreStyleAnyFilter(
        filters: null == filters
            ? _self._filters
            : filters // ignore: cast_nullable_to_non_nullable
                  as List<MateoMapLibreStyleFilter>,
      ),
    );
  }
}
