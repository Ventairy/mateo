// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mateo_map_style_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MateoMapLibreStyleZoomStop {
  /// The zoom level for this stop. Integer zoom levels (e.g. `10`) match
  /// discrete zoom transitions; fractional values would produce
  /// interpolated results.
  num get zoom;

  /// The paint or layout property value at this stop's zoom level.
  /// The type depends on the property (pixel width, font size, opacity, etc.).
  num get value;

  /// Create a copy of MateoMapLibreStyleZoomStop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleZoomStopCopyWith<MateoMapLibreStyleZoomStop>
  get copyWith =>
      _$MateoMapLibreStyleZoomStopCopyWithImpl<MateoMapLibreStyleZoomStop>(
        this as MateoMapLibreStyleZoomStop,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyleZoomStop &&
            (identical(other.zoom, zoom) || other.zoom == zoom) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, zoom, value);

  @override
  String toString() {
    return 'MateoMapLibreStyleZoomStop(zoom: $zoom, value: $value)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleZoomStopCopyWith<$Res> {
  factory $MateoMapLibreStyleZoomStopCopyWith(
    MateoMapLibreStyleZoomStop value,
    $Res Function(MateoMapLibreStyleZoomStop) _then,
  ) = _$MateoMapLibreStyleZoomStopCopyWithImpl;
  @useResult
  $Res call({num zoom, num value});
}

/// @nodoc
class _$MateoMapLibreStyleZoomStopCopyWithImpl<$Res>
    implements $MateoMapLibreStyleZoomStopCopyWith<$Res> {
  _$MateoMapLibreStyleZoomStopCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyleZoomStop _self;
  final $Res Function(MateoMapLibreStyleZoomStop) _then;

  /// Create a copy of MateoMapLibreStyleZoomStop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? zoom = null, Object? value = null}) {
    return _then(
      _self.copyWith(
        zoom: null == zoom
            ? _self.zoom
            : zoom // ignore: cast_nullable_to_non_nullable
                  as num,
        value: null == value
            ? _self.value
            : value // ignore: cast_nullable_to_non_nullable
                  as num,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [MateoMapLibreStyleZoomStop].
extension MateoMapLibreStyleZoomStopPatterns on MateoMapLibreStyleZoomStop {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MateoMapLibreStyleZoomStop value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleZoomStop() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_MateoMapLibreStyleZoomStop value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleZoomStop():
        return $default(_that);
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MateoMapLibreStyleZoomStop value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleZoomStop() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(num zoom, num value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleZoomStop() when $default != null:
        return $default(_that.zoom, _that.value);
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
  TResult when<TResult extends Object?>(
    TResult Function(num zoom, num value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleZoomStop():
        return $default(_that.zoom, _that.value);
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(num zoom, num value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleZoomStop() when $default != null:
        return $default(_that.zoom, _that.value);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MateoMapLibreStyleZoomStop implements MateoMapLibreStyleZoomStop {
  const _MateoMapLibreStyleZoomStop({required this.zoom, required this.value});

  /// The zoom level for this stop. Integer zoom levels (e.g. `10`) match
  /// discrete zoom transitions; fractional values would produce
  /// interpolated results.
  @override
  final num zoom;

  /// The paint or layout property value at this stop's zoom level.
  /// The type depends on the property (pixel width, font size, opacity, etc.).
  @override
  final num value;

  /// Create a copy of MateoMapLibreStyleZoomStop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MateoMapLibreStyleZoomStopCopyWith<_MateoMapLibreStyleZoomStop>
  get copyWith =>
      __$MateoMapLibreStyleZoomStopCopyWithImpl<_MateoMapLibreStyleZoomStop>(
        this,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MateoMapLibreStyleZoomStop &&
            (identical(other.zoom, zoom) || other.zoom == zoom) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, zoom, value);

  @override
  String toString() {
    return 'MateoMapLibreStyleZoomStop(zoom: $zoom, value: $value)';
  }
}

/// @nodoc
abstract mixin class _$MateoMapLibreStyleZoomStopCopyWith<$Res>
    implements $MateoMapLibreStyleZoomStopCopyWith<$Res> {
  factory _$MateoMapLibreStyleZoomStopCopyWith(
    _MateoMapLibreStyleZoomStop value,
    $Res Function(_MateoMapLibreStyleZoomStop) _then,
  ) = __$MateoMapLibreStyleZoomStopCopyWithImpl;
  @override
  @useResult
  $Res call({num zoom, num value});
}

/// @nodoc
class __$MateoMapLibreStyleZoomStopCopyWithImpl<$Res>
    implements _$MateoMapLibreStyleZoomStopCopyWith<$Res> {
  __$MateoMapLibreStyleZoomStopCopyWithImpl(this._self, this._then);

  final _MateoMapLibreStyleZoomStop _self;
  final $Res Function(_MateoMapLibreStyleZoomStop) _then;

  /// Create a copy of MateoMapLibreStyleZoomStop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? zoom = null, Object? value = null}) {
    return _then(
      _MateoMapLibreStyleZoomStop(
        zoom: null == zoom
            ? _self.zoom
            : zoom // ignore: cast_nullable_to_non_nullable
                  as num,
        value: null == value
            ? _self.value
            : value // ignore: cast_nullable_to_non_nullable
                  as num,
      ),
    );
  }
}

/// @nodoc
mixin _$MateoMapLibreStyleValue {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MateoMapLibreStyleValue);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MateoMapLibreStyleValue()';
  }
}

/// @nodoc
class $MateoMapLibreStyleValueCopyWith<$Res> {
  $MateoMapLibreStyleValueCopyWith(
    MateoMapLibreStyleValue _,
    $Res Function(MateoMapLibreStyleValue) __,
  );
}

/// Adds pattern-matching-related methods to [MateoMapLibreStyleValue].
extension MateoMapLibreStyleValuePatterns on MateoMapLibreStyleValue {
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
    TResult Function(MateoMapLibreStyleScalarValue value)? scalar,
    TResult Function(MateoMapLibreStyleStopsValue value)? stops,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapLibreStyleScalarValue() when scalar != null:
        return scalar(_that);
      case MateoMapLibreStyleStopsValue() when stops != null:
        return stops(_that);
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
    required TResult Function(MateoMapLibreStyleScalarValue value) scalar,
    required TResult Function(MateoMapLibreStyleStopsValue value) stops,
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapLibreStyleScalarValue():
        return scalar(_that);
      case MateoMapLibreStyleStopsValue():
        return stops(_that);
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
    TResult? Function(MateoMapLibreStyleScalarValue value)? scalar,
    TResult? Function(MateoMapLibreStyleStopsValue value)? stops,
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapLibreStyleScalarValue() when scalar != null:
        return scalar(_that);
      case MateoMapLibreStyleStopsValue() when stops != null:
        return stops(_that);
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
    TResult Function(num value)? scalar,
    TResult Function(List<MateoMapLibreStyleZoomStop> stops)? stops,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapLibreStyleScalarValue() when scalar != null:
        return scalar(_that.value);
      case MateoMapLibreStyleStopsValue() when stops != null:
        return stops(_that.stops);
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
    required TResult Function(num value) scalar,
    required TResult Function(List<MateoMapLibreStyleZoomStop> stops) stops,
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapLibreStyleScalarValue():
        return scalar(_that.value);
      case MateoMapLibreStyleStopsValue():
        return stops(_that.stops);
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
    TResult? Function(num value)? scalar,
    TResult? Function(List<MateoMapLibreStyleZoomStop> stops)? stops,
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapLibreStyleScalarValue() when scalar != null:
        return scalar(_that.value);
      case MateoMapLibreStyleStopsValue() when stops != null:
        return stops(_that.stops);
      case _:
        return null;
    }
  }
}

/// @nodoc

class MateoMapLibreStyleScalarValue implements MateoMapLibreStyleValue {
  const MateoMapLibreStyleScalarValue(this.value);

  final num value;

  /// Create a copy of MateoMapLibreStyleValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleScalarValueCopyWith<MateoMapLibreStyleScalarValue>
  get copyWith =>
      _$MateoMapLibreStyleScalarValueCopyWithImpl<
        MateoMapLibreStyleScalarValue
      >(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyleScalarValue &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() {
    return 'MateoMapLibreStyleValue.scalar(value: $value)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleScalarValueCopyWith<$Res>
    implements $MateoMapLibreStyleValueCopyWith<$Res> {
  factory $MateoMapLibreStyleScalarValueCopyWith(
    MateoMapLibreStyleScalarValue value,
    $Res Function(MateoMapLibreStyleScalarValue) _then,
  ) = _$MateoMapLibreStyleScalarValueCopyWithImpl;
  @useResult
  $Res call({num value});
}

/// @nodoc
class _$MateoMapLibreStyleScalarValueCopyWithImpl<$Res>
    implements $MateoMapLibreStyleScalarValueCopyWith<$Res> {
  _$MateoMapLibreStyleScalarValueCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyleScalarValue _self;
  final $Res Function(MateoMapLibreStyleScalarValue) _then;

  /// Create a copy of MateoMapLibreStyleValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({Object? value = null}) {
    return _then(
      MateoMapLibreStyleScalarValue(
        null == value
            ? _self.value
            : value // ignore: cast_nullable_to_non_nullable
                  as num,
      ),
    );
  }
}

/// @nodoc

class MateoMapLibreStyleStopsValue implements MateoMapLibreStyleValue {
  const MateoMapLibreStyleStopsValue(
    final List<MateoMapLibreStyleZoomStop> stops,
  ) : _stops = stops;

  final List<MateoMapLibreStyleZoomStop> _stops;
  List<MateoMapLibreStyleZoomStop> get stops {
    if (_stops is EqualUnmodifiableListView) return _stops;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stops);
  }

  /// Create a copy of MateoMapLibreStyleValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleStopsValueCopyWith<MateoMapLibreStyleStopsValue>
  get copyWith =>
      _$MateoMapLibreStyleStopsValueCopyWithImpl<MateoMapLibreStyleStopsValue>(
        this,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyleStopsValue &&
            const DeepCollectionEquality().equals(other._stops, _stops));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_stops));

  @override
  String toString() {
    return 'MateoMapLibreStyleValue.stops(stops: $stops)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleStopsValueCopyWith<$Res>
    implements $MateoMapLibreStyleValueCopyWith<$Res> {
  factory $MateoMapLibreStyleStopsValueCopyWith(
    MateoMapLibreStyleStopsValue value,
    $Res Function(MateoMapLibreStyleStopsValue) _then,
  ) = _$MateoMapLibreStyleStopsValueCopyWithImpl;
  @useResult
  $Res call({List<MateoMapLibreStyleZoomStop> stops});
}

/// @nodoc
class _$MateoMapLibreStyleStopsValueCopyWithImpl<$Res>
    implements $MateoMapLibreStyleStopsValueCopyWith<$Res> {
  _$MateoMapLibreStyleStopsValueCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyleStopsValue _self;
  final $Res Function(MateoMapLibreStyleStopsValue) _then;

  /// Create a copy of MateoMapLibreStyleValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({Object? stops = null}) {
    return _then(
      MateoMapLibreStyleStopsValue(
        null == stops
            ? _self._stops
            : stops // ignore: cast_nullable_to_non_nullable
                  as List<MateoMapLibreStyleZoomStop>,
      ),
    );
  }
}
