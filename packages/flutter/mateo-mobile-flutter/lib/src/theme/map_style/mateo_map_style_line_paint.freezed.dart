// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mateo_map_style_line_paint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MateoMapLibreStyleLinePaint {
  /// The line color as a hex string (e.g. `"#ffffff"`).
  ///
  /// Mapped to the `line-color` JSON key.
  @JsonKey(name: 'line-color')
  String get lineColor;

  /// The line width, which may be a constant scalar or a zoom-dependent stop
  /// function.
  ///
  /// Mapped to the `line-width` JSON key. Uses [MateoMapLibreStyleValueConverter]
  /// to serialize as either a raw number or a stops object.
  /// See [MateoMapLibreStyleValue] for value representations.
  @JsonKey(name: 'line-width')
  @MateoMapLibreStyleValueConverter()
  MateoMapLibreStyleValue get lineWidth;

  /// The line opacity from 0 (transparent) to 1 (opaque).
  ///
  /// Mapped to the `line-opacity` JSON key.
  @JsonKey(name: 'line-opacity')
  double get lineOpacity;

  /// Create a copy of MateoMapLibreStyleLinePaint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleLinePaintCopyWith<MateoMapLibreStyleLinePaint>
  get copyWith =>
      _$MateoMapLibreStyleLinePaintCopyWithImpl<MateoMapLibreStyleLinePaint>(
        this as MateoMapLibreStyleLinePaint,
        _$identity,
      );

  /// Serializes this MateoMapLibreStyleLinePaint to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyleLinePaint &&
            (identical(other.lineColor, lineColor) ||
                other.lineColor == lineColor) &&
            (identical(other.lineWidth, lineWidth) ||
                other.lineWidth == lineWidth) &&
            (identical(other.lineOpacity, lineOpacity) ||
                other.lineOpacity == lineOpacity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, lineColor, lineWidth, lineOpacity);

  @override
  String toString() {
    return 'MateoMapLibreStyleLinePaint(lineColor: $lineColor, lineWidth: $lineWidth, lineOpacity: $lineOpacity)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleLinePaintCopyWith<$Res> {
  factory $MateoMapLibreStyleLinePaintCopyWith(
    MateoMapLibreStyleLinePaint value,
    $Res Function(MateoMapLibreStyleLinePaint) _then,
  ) = _$MateoMapLibreStyleLinePaintCopyWithImpl;
  @useResult
  $Res call({
    @JsonKey(name: 'line-color') String lineColor,
    @JsonKey(name: 'line-width')
    @MateoMapLibreStyleValueConverter()
    MateoMapLibreStyleValue lineWidth,
    @JsonKey(name: 'line-opacity') double lineOpacity,
  });

  $MateoMapLibreStyleValueCopyWith<$Res> get lineWidth;
}

/// @nodoc
class _$MateoMapLibreStyleLinePaintCopyWithImpl<$Res>
    implements $MateoMapLibreStyleLinePaintCopyWith<$Res> {
  _$MateoMapLibreStyleLinePaintCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyleLinePaint _self;
  final $Res Function(MateoMapLibreStyleLinePaint) _then;

  /// Create a copy of MateoMapLibreStyleLinePaint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lineColor = null,
    Object? lineWidth = null,
    Object? lineOpacity = null,
  }) {
    return _then(
      _self.copyWith(
        lineColor: null == lineColor
            ? _self.lineColor
            : lineColor // ignore: cast_nullable_to_non_nullable
                  as String,
        lineWidth: null == lineWidth
            ? _self.lineWidth
            : lineWidth // ignore: cast_nullable_to_non_nullable
                  as MateoMapLibreStyleValue,
        lineOpacity: null == lineOpacity
            ? _self.lineOpacity
            : lineOpacity // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }

  /// Create a copy of MateoMapLibreStyleLinePaint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleValueCopyWith<$Res> get lineWidth {
    return $MateoMapLibreStyleValueCopyWith<$Res>(_self.lineWidth, (value) {
      return _then(_self.copyWith(lineWidth: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MateoMapLibreStyleLinePaint].
extension MateoMapLibreStyleLinePaintPatterns on MateoMapLibreStyleLinePaint {
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
    TResult Function(_MateoMapLibreStyleLinePaint value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleLinePaint() when $default != null:
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
    TResult Function(_MateoMapLibreStyleLinePaint value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleLinePaint():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(_MateoMapLibreStyleLinePaint value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleLinePaint() when $default != null:
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
    TResult Function(
      @JsonKey(name: 'line-color') String lineColor,
      @JsonKey(name: 'line-width')
      @MateoMapLibreStyleValueConverter()
      MateoMapLibreStyleValue lineWidth,
      @JsonKey(name: 'line-opacity') double lineOpacity,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleLinePaint() when $default != null:
        return $default(_that.lineColor, _that.lineWidth, _that.lineOpacity);
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
    TResult Function(
      @JsonKey(name: 'line-color') String lineColor,
      @JsonKey(name: 'line-width')
      @MateoMapLibreStyleValueConverter()
      MateoMapLibreStyleValue lineWidth,
      @JsonKey(name: 'line-opacity') double lineOpacity,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleLinePaint():
        return $default(_that.lineColor, _that.lineWidth, _that.lineOpacity);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(
      @JsonKey(name: 'line-color') String lineColor,
      @JsonKey(name: 'line-width')
      @MateoMapLibreStyleValueConverter()
      MateoMapLibreStyleValue lineWidth,
      @JsonKey(name: 'line-opacity') double lineOpacity,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleLinePaint() when $default != null:
        return $default(_that.lineColor, _that.lineWidth, _that.lineOpacity);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable(createFactory: false)
class _MateoMapLibreStyleLinePaint implements MateoMapLibreStyleLinePaint {
  const _MateoMapLibreStyleLinePaint({
    @JsonKey(name: 'line-color') required this.lineColor,
    @JsonKey(name: 'line-width')
    @MateoMapLibreStyleValueConverter()
    required this.lineWidth,
    @JsonKey(name: 'line-opacity') required this.lineOpacity,
  });

  /// The line color as a hex string (e.g. `"#ffffff"`).
  ///
  /// Mapped to the `line-color` JSON key.
  @override
  @JsonKey(name: 'line-color')
  final String lineColor;

  /// The line width, which may be a constant scalar or a zoom-dependent stop
  /// function.
  ///
  /// Mapped to the `line-width` JSON key. Uses [MateoMapLibreStyleValueConverter]
  /// to serialize as either a raw number or a stops object.
  /// See [MateoMapLibreStyleValue] for value representations.
  @override
  @JsonKey(name: 'line-width')
  @MateoMapLibreStyleValueConverter()
  final MateoMapLibreStyleValue lineWidth;

  /// The line opacity from 0 (transparent) to 1 (opaque).
  ///
  /// Mapped to the `line-opacity` JSON key.
  @override
  @JsonKey(name: 'line-opacity')
  final double lineOpacity;

  /// Create a copy of MateoMapLibreStyleLinePaint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MateoMapLibreStyleLinePaintCopyWith<_MateoMapLibreStyleLinePaint>
  get copyWith =>
      __$MateoMapLibreStyleLinePaintCopyWithImpl<_MateoMapLibreStyleLinePaint>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$MateoMapLibreStyleLinePaintToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MateoMapLibreStyleLinePaint &&
            (identical(other.lineColor, lineColor) ||
                other.lineColor == lineColor) &&
            (identical(other.lineWidth, lineWidth) ||
                other.lineWidth == lineWidth) &&
            (identical(other.lineOpacity, lineOpacity) ||
                other.lineOpacity == lineOpacity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, lineColor, lineWidth, lineOpacity);

  @override
  String toString() {
    return 'MateoMapLibreStyleLinePaint(lineColor: $lineColor, lineWidth: $lineWidth, lineOpacity: $lineOpacity)';
  }
}

/// @nodoc
abstract mixin class _$MateoMapLibreStyleLinePaintCopyWith<$Res>
    implements $MateoMapLibreStyleLinePaintCopyWith<$Res> {
  factory _$MateoMapLibreStyleLinePaintCopyWith(
    _MateoMapLibreStyleLinePaint value,
    $Res Function(_MateoMapLibreStyleLinePaint) _then,
  ) = __$MateoMapLibreStyleLinePaintCopyWithImpl;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'line-color') String lineColor,
    @JsonKey(name: 'line-width')
    @MateoMapLibreStyleValueConverter()
    MateoMapLibreStyleValue lineWidth,
    @JsonKey(name: 'line-opacity') double lineOpacity,
  });

  @override
  $MateoMapLibreStyleValueCopyWith<$Res> get lineWidth;
}

/// @nodoc
class __$MateoMapLibreStyleLinePaintCopyWithImpl<$Res>
    implements _$MateoMapLibreStyleLinePaintCopyWith<$Res> {
  __$MateoMapLibreStyleLinePaintCopyWithImpl(this._self, this._then);

  final _MateoMapLibreStyleLinePaint _self;
  final $Res Function(_MateoMapLibreStyleLinePaint) _then;

  /// Create a copy of MateoMapLibreStyleLinePaint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? lineColor = null,
    Object? lineWidth = null,
    Object? lineOpacity = null,
  }) {
    return _then(
      _MateoMapLibreStyleLinePaint(
        lineColor: null == lineColor
            ? _self.lineColor
            : lineColor // ignore: cast_nullable_to_non_nullable
                  as String,
        lineWidth: null == lineWidth
            ? _self.lineWidth
            : lineWidth // ignore: cast_nullable_to_non_nullable
                  as MateoMapLibreStyleValue,
        lineOpacity: null == lineOpacity
            ? _self.lineOpacity
            : lineOpacity // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }

  /// Create a copy of MateoMapLibreStyleLinePaint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleValueCopyWith<$Res> get lineWidth {
    return $MateoMapLibreStyleValueCopyWith<$Res>(_self.lineWidth, (value) {
      return _then(_self.copyWith(lineWidth: value));
    });
  }
}
