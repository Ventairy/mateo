// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mateo_map_style_symbol_paint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MateoMapLibreStyleSymbolPaint {
  /// The text fill color as a hex string (e.g. `"#555657"`).
  ///
  /// Mapped to the `text-color` JSON key.
  @JsonKey(name: 'text-color')
  String get textColor;

  /// The color of the text halo (outline) as a hex string.
  ///
  /// Mapped to the `text-halo-color` JSON key. A white halo improves
  /// legibility against varied backgrounds.
  @JsonKey(name: 'text-halo-color')
  String get textHaloColor;

  /// The width of the text halo in pixels.
  ///
  /// Mapped to the `text-halo-width` JSON key.
  @JsonKey(name: 'text-halo-width')
  double get textHaloWidth;

  /// The text opacity from 0 (transparent) to 1 (opaque).
  ///
  /// Mapped to the `text-opacity` JSON key. When null, defaults to 1
  /// in MapLibre.
  @JsonKey(name: 'text-opacity')
  double? get textOpacity;

  /// Create a copy of MateoMapLibreStyleSymbolPaint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleSymbolPaintCopyWith<MateoMapLibreStyleSymbolPaint>
  get copyWith =>
      _$MateoMapLibreStyleSymbolPaintCopyWithImpl<
        MateoMapLibreStyleSymbolPaint
      >(this as MateoMapLibreStyleSymbolPaint, _$identity);

  /// Serializes this MateoMapLibreStyleSymbolPaint to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyleSymbolPaint &&
            (identical(other.textColor, textColor) ||
                other.textColor == textColor) &&
            (identical(other.textHaloColor, textHaloColor) ||
                other.textHaloColor == textHaloColor) &&
            (identical(other.textHaloWidth, textHaloWidth) ||
                other.textHaloWidth == textHaloWidth) &&
            (identical(other.textOpacity, textOpacity) ||
                other.textOpacity == textOpacity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    textColor,
    textHaloColor,
    textHaloWidth,
    textOpacity,
  );

  @override
  String toString() {
    return 'MateoMapLibreStyleSymbolPaint(textColor: $textColor, textHaloColor: $textHaloColor, textHaloWidth: $textHaloWidth, textOpacity: $textOpacity)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleSymbolPaintCopyWith<$Res> {
  factory $MateoMapLibreStyleSymbolPaintCopyWith(
    MateoMapLibreStyleSymbolPaint value,
    $Res Function(MateoMapLibreStyleSymbolPaint) _then,
  ) = _$MateoMapLibreStyleSymbolPaintCopyWithImpl;
  @useResult
  $Res call({
    @JsonKey(name: 'text-color') String textColor,
    @JsonKey(name: 'text-halo-color') String textHaloColor,
    @JsonKey(name: 'text-halo-width') double textHaloWidth,
    @JsonKey(name: 'text-opacity') double? textOpacity,
  });
}

/// @nodoc
class _$MateoMapLibreStyleSymbolPaintCopyWithImpl<$Res>
    implements $MateoMapLibreStyleSymbolPaintCopyWith<$Res> {
  _$MateoMapLibreStyleSymbolPaintCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyleSymbolPaint _self;
  final $Res Function(MateoMapLibreStyleSymbolPaint) _then;

  /// Create a copy of MateoMapLibreStyleSymbolPaint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? textColor = null,
    Object? textHaloColor = null,
    Object? textHaloWidth = null,
    Object? textOpacity = freezed,
  }) {
    return _then(
      _self.copyWith(
        textColor: null == textColor
            ? _self.textColor
            : textColor // ignore: cast_nullable_to_non_nullable
                  as String,
        textHaloColor: null == textHaloColor
            ? _self.textHaloColor
            : textHaloColor // ignore: cast_nullable_to_non_nullable
                  as String,
        textHaloWidth: null == textHaloWidth
            ? _self.textHaloWidth
            : textHaloWidth // ignore: cast_nullable_to_non_nullable
                  as double,
        textOpacity: freezed == textOpacity
            ? _self.textOpacity
            : textOpacity // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [MateoMapLibreStyleSymbolPaint].
extension MateoMapLibreStyleSymbolPaintPatterns
    on MateoMapLibreStyleSymbolPaint {
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
    TResult Function(_MateoMapLibreStyleSymbolPaint value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSymbolPaint() when $default != null:
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
    TResult Function(_MateoMapLibreStyleSymbolPaint value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSymbolPaint():
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
    TResult? Function(_MateoMapLibreStyleSymbolPaint value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSymbolPaint() when $default != null:
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
      @JsonKey(name: 'text-color') String textColor,
      @JsonKey(name: 'text-halo-color') String textHaloColor,
      @JsonKey(name: 'text-halo-width') double textHaloWidth,
      @JsonKey(name: 'text-opacity') double? textOpacity,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSymbolPaint() when $default != null:
        return $default(
          _that.textColor,
          _that.textHaloColor,
          _that.textHaloWidth,
          _that.textOpacity,
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
      @JsonKey(name: 'text-color') String textColor,
      @JsonKey(name: 'text-halo-color') String textHaloColor,
      @JsonKey(name: 'text-halo-width') double textHaloWidth,
      @JsonKey(name: 'text-opacity') double? textOpacity,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSymbolPaint():
        return $default(
          _that.textColor,
          _that.textHaloColor,
          _that.textHaloWidth,
          _that.textOpacity,
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
      @JsonKey(name: 'text-color') String textColor,
      @JsonKey(name: 'text-halo-color') String textHaloColor,
      @JsonKey(name: 'text-halo-width') double textHaloWidth,
      @JsonKey(name: 'text-opacity') double? textOpacity,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSymbolPaint() when $default != null:
        return $default(
          _that.textColor,
          _that.textHaloColor,
          _that.textHaloWidth,
          _that.textOpacity,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable(createFactory: false)
class _MateoMapLibreStyleSymbolPaint implements MateoMapLibreStyleSymbolPaint {
  const _MateoMapLibreStyleSymbolPaint({
    @JsonKey(name: 'text-color') required this.textColor,
    @JsonKey(name: 'text-halo-color') required this.textHaloColor,
    @JsonKey(name: 'text-halo-width') required this.textHaloWidth,
    @JsonKey(name: 'text-opacity') this.textOpacity,
  });

  /// The text fill color as a hex string (e.g. `"#555657"`).
  ///
  /// Mapped to the `text-color` JSON key.
  @override
  @JsonKey(name: 'text-color')
  final String textColor;

  /// The color of the text halo (outline) as a hex string.
  ///
  /// Mapped to the `text-halo-color` JSON key. A white halo improves
  /// legibility against varied backgrounds.
  @override
  @JsonKey(name: 'text-halo-color')
  final String textHaloColor;

  /// The width of the text halo in pixels.
  ///
  /// Mapped to the `text-halo-width` JSON key.
  @override
  @JsonKey(name: 'text-halo-width')
  final double textHaloWidth;

  /// The text opacity from 0 (transparent) to 1 (opaque).
  ///
  /// Mapped to the `text-opacity` JSON key. When null, defaults to 1
  /// in MapLibre.
  @override
  @JsonKey(name: 'text-opacity')
  final double? textOpacity;

  /// Create a copy of MateoMapLibreStyleSymbolPaint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MateoMapLibreStyleSymbolPaintCopyWith<_MateoMapLibreStyleSymbolPaint>
  get copyWith =>
      __$MateoMapLibreStyleSymbolPaintCopyWithImpl<
        _MateoMapLibreStyleSymbolPaint
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MateoMapLibreStyleSymbolPaintToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MateoMapLibreStyleSymbolPaint &&
            (identical(other.textColor, textColor) ||
                other.textColor == textColor) &&
            (identical(other.textHaloColor, textHaloColor) ||
                other.textHaloColor == textHaloColor) &&
            (identical(other.textHaloWidth, textHaloWidth) ||
                other.textHaloWidth == textHaloWidth) &&
            (identical(other.textOpacity, textOpacity) ||
                other.textOpacity == textOpacity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    textColor,
    textHaloColor,
    textHaloWidth,
    textOpacity,
  );

  @override
  String toString() {
    return 'MateoMapLibreStyleSymbolPaint(textColor: $textColor, textHaloColor: $textHaloColor, textHaloWidth: $textHaloWidth, textOpacity: $textOpacity)';
  }
}

/// @nodoc
abstract mixin class _$MateoMapLibreStyleSymbolPaintCopyWith<$Res>
    implements $MateoMapLibreStyleSymbolPaintCopyWith<$Res> {
  factory _$MateoMapLibreStyleSymbolPaintCopyWith(
    _MateoMapLibreStyleSymbolPaint value,
    $Res Function(_MateoMapLibreStyleSymbolPaint) _then,
  ) = __$MateoMapLibreStyleSymbolPaintCopyWithImpl;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'text-color') String textColor,
    @JsonKey(name: 'text-halo-color') String textHaloColor,
    @JsonKey(name: 'text-halo-width') double textHaloWidth,
    @JsonKey(name: 'text-opacity') double? textOpacity,
  });
}

/// @nodoc
class __$MateoMapLibreStyleSymbolPaintCopyWithImpl<$Res>
    implements _$MateoMapLibreStyleSymbolPaintCopyWith<$Res> {
  __$MateoMapLibreStyleSymbolPaintCopyWithImpl(this._self, this._then);

  final _MateoMapLibreStyleSymbolPaint _self;
  final $Res Function(_MateoMapLibreStyleSymbolPaint) _then;

  /// Create a copy of MateoMapLibreStyleSymbolPaint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? textColor = null,
    Object? textHaloColor = null,
    Object? textHaloWidth = null,
    Object? textOpacity = freezed,
  }) {
    return _then(
      _MateoMapLibreStyleSymbolPaint(
        textColor: null == textColor
            ? _self.textColor
            : textColor // ignore: cast_nullable_to_non_nullable
                  as String,
        textHaloColor: null == textHaloColor
            ? _self.textHaloColor
            : textHaloColor // ignore: cast_nullable_to_non_nullable
                  as String,
        textHaloWidth: null == textHaloWidth
            ? _self.textHaloWidth
            : textHaloWidth // ignore: cast_nullable_to_non_nullable
                  as double,
        textOpacity: freezed == textOpacity
            ? _self.textOpacity
            : textOpacity // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}
