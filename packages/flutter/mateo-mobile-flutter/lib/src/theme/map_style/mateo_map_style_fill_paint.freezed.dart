// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mateo_map_style_fill_paint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MateoMapLibreStyleFillPaint {
  /// The fill color as a hex string (e.g. `"#d7d9db"`).
  ///
  /// Mapped to the `fill-color` JSON key.
  @JsonKey(name: 'fill-color')
  String get fillColor;

  /// The fill opacity from 0 (transparent) to 1 (opaque).
  ///
  /// Mapped to the `fill-opacity` JSON key.
  @JsonKey(name: 'fill-opacity')
  double get fillOpacity;

  /// Optional outline color for fill polygons.
  ///
  /// Mapped to the `fill-outline-color` JSON key. When null, the outline
  /// uses the same color as the fill. Only rendered for polygons; ignored
  /// for point or line data.
  @JsonKey(name: 'fill-outline-color')
  String? get fillOutlineColor;

  /// Create a copy of MateoMapLibreStyleFillPaint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleFillPaintCopyWith<MateoMapLibreStyleFillPaint>
  get copyWith =>
      _$MateoMapLibreStyleFillPaintCopyWithImpl<MateoMapLibreStyleFillPaint>(
        this as MateoMapLibreStyleFillPaint,
        _$identity,
      );

  /// Serializes this MateoMapLibreStyleFillPaint to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyleFillPaint &&
            (identical(other.fillColor, fillColor) ||
                other.fillColor == fillColor) &&
            (identical(other.fillOpacity, fillOpacity) ||
                other.fillOpacity == fillOpacity) &&
            (identical(other.fillOutlineColor, fillOutlineColor) ||
                other.fillOutlineColor == fillOutlineColor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, fillColor, fillOpacity, fillOutlineColor);

  @override
  String toString() {
    return 'MateoMapLibreStyleFillPaint(fillColor: $fillColor, fillOpacity: $fillOpacity, fillOutlineColor: $fillOutlineColor)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleFillPaintCopyWith<$Res> {
  factory $MateoMapLibreStyleFillPaintCopyWith(
    MateoMapLibreStyleFillPaint value,
    $Res Function(MateoMapLibreStyleFillPaint) _then,
  ) = _$MateoMapLibreStyleFillPaintCopyWithImpl;
  @useResult
  $Res call({
    @JsonKey(name: 'fill-color') String fillColor,
    @JsonKey(name: 'fill-opacity') double fillOpacity,
    @JsonKey(name: 'fill-outline-color') String? fillOutlineColor,
  });
}

/// @nodoc
class _$MateoMapLibreStyleFillPaintCopyWithImpl<$Res>
    implements $MateoMapLibreStyleFillPaintCopyWith<$Res> {
  _$MateoMapLibreStyleFillPaintCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyleFillPaint _self;
  final $Res Function(MateoMapLibreStyleFillPaint) _then;

  /// Create a copy of MateoMapLibreStyleFillPaint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fillColor = null,
    Object? fillOpacity = null,
    Object? fillOutlineColor = freezed,
  }) {
    return _then(
      _self.copyWith(
        fillColor: null == fillColor
            ? _self.fillColor
            : fillColor // ignore: cast_nullable_to_non_nullable
                  as String,
        fillOpacity: null == fillOpacity
            ? _self.fillOpacity
            : fillOpacity // ignore: cast_nullable_to_non_nullable
                  as double,
        fillOutlineColor: freezed == fillOutlineColor
            ? _self.fillOutlineColor
            : fillOutlineColor // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [MateoMapLibreStyleFillPaint].
extension MateoMapLibreStyleFillPaintPatterns on MateoMapLibreStyleFillPaint {
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
    TResult Function(_MateoMapLibreStyleFillPaint value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleFillPaint() when $default != null:
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
    TResult Function(_MateoMapLibreStyleFillPaint value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleFillPaint():
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
    TResult? Function(_MateoMapLibreStyleFillPaint value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleFillPaint() when $default != null:
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
      @JsonKey(name: 'fill-color') String fillColor,
      @JsonKey(name: 'fill-opacity') double fillOpacity,
      @JsonKey(name: 'fill-outline-color') String? fillOutlineColor,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleFillPaint() when $default != null:
        return $default(
          _that.fillColor,
          _that.fillOpacity,
          _that.fillOutlineColor,
        );
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
      @JsonKey(name: 'fill-color') String fillColor,
      @JsonKey(name: 'fill-opacity') double fillOpacity,
      @JsonKey(name: 'fill-outline-color') String? fillOutlineColor,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleFillPaint():
        return $default(
          _that.fillColor,
          _that.fillOpacity,
          _that.fillOutlineColor,
        );
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
      @JsonKey(name: 'fill-color') String fillColor,
      @JsonKey(name: 'fill-opacity') double fillOpacity,
      @JsonKey(name: 'fill-outline-color') String? fillOutlineColor,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleFillPaint() when $default != null:
        return $default(
          _that.fillColor,
          _that.fillOpacity,
          _that.fillOutlineColor,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable(createFactory: false)
class _MateoMapLibreStyleFillPaint implements MateoMapLibreStyleFillPaint {
  const _MateoMapLibreStyleFillPaint({
    @JsonKey(name: 'fill-color') required this.fillColor,
    @JsonKey(name: 'fill-opacity') required this.fillOpacity,
    @JsonKey(name: 'fill-outline-color') this.fillOutlineColor,
  });

  /// The fill color as a hex string (e.g. `"#d7d9db"`).
  ///
  /// Mapped to the `fill-color` JSON key.
  @override
  @JsonKey(name: 'fill-color')
  final String fillColor;

  /// The fill opacity from 0 (transparent) to 1 (opaque).
  ///
  /// Mapped to the `fill-opacity` JSON key.
  @override
  @JsonKey(name: 'fill-opacity')
  final double fillOpacity;

  /// Optional outline color for fill polygons.
  ///
  /// Mapped to the `fill-outline-color` JSON key. When null, the outline
  /// uses the same color as the fill. Only rendered for polygons; ignored
  /// for point or line data.
  @override
  @JsonKey(name: 'fill-outline-color')
  final String? fillOutlineColor;

  /// Create a copy of MateoMapLibreStyleFillPaint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MateoMapLibreStyleFillPaintCopyWith<_MateoMapLibreStyleFillPaint>
  get copyWith =>
      __$MateoMapLibreStyleFillPaintCopyWithImpl<_MateoMapLibreStyleFillPaint>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$MateoMapLibreStyleFillPaintToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MateoMapLibreStyleFillPaint &&
            (identical(other.fillColor, fillColor) ||
                other.fillColor == fillColor) &&
            (identical(other.fillOpacity, fillOpacity) ||
                other.fillOpacity == fillOpacity) &&
            (identical(other.fillOutlineColor, fillOutlineColor) ||
                other.fillOutlineColor == fillOutlineColor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, fillColor, fillOpacity, fillOutlineColor);

  @override
  String toString() {
    return 'MateoMapLibreStyleFillPaint(fillColor: $fillColor, fillOpacity: $fillOpacity, fillOutlineColor: $fillOutlineColor)';
  }
}

/// @nodoc
abstract mixin class _$MateoMapLibreStyleFillPaintCopyWith<$Res>
    implements $MateoMapLibreStyleFillPaintCopyWith<$Res> {
  factory _$MateoMapLibreStyleFillPaintCopyWith(
    _MateoMapLibreStyleFillPaint value,
    $Res Function(_MateoMapLibreStyleFillPaint) _then,
  ) = __$MateoMapLibreStyleFillPaintCopyWithImpl;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'fill-color') String fillColor,
    @JsonKey(name: 'fill-opacity') double fillOpacity,
    @JsonKey(name: 'fill-outline-color') String? fillOutlineColor,
  });
}

/// @nodoc
class __$MateoMapLibreStyleFillPaintCopyWithImpl<$Res>
    implements _$MateoMapLibreStyleFillPaintCopyWith<$Res> {
  __$MateoMapLibreStyleFillPaintCopyWithImpl(this._self, this._then);

  final _MateoMapLibreStyleFillPaint _self;
  final $Res Function(_MateoMapLibreStyleFillPaint) _then;

  /// Create a copy of MateoMapLibreStyleFillPaint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? fillColor = null,
    Object? fillOpacity = null,
    Object? fillOutlineColor = freezed,
  }) {
    return _then(
      _MateoMapLibreStyleFillPaint(
        fillColor: null == fillColor
            ? _self.fillColor
            : fillColor // ignore: cast_nullable_to_non_nullable
                  as String,
        fillOpacity: null == fillOpacity
            ? _self.fillOpacity
            : fillOpacity // ignore: cast_nullable_to_non_nullable
                  as double,
        fillOutlineColor: freezed == fillOutlineColor
            ? _self.fillOutlineColor
            : fillOutlineColor // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
