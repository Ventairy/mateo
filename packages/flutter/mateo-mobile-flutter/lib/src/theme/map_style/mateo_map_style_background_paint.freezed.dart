// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mateo_map_style_background_paint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MateoMapLibreStyleBackgroundPaint {
  /// The background fill color as a hex string (e.g. `"#ebedef"`).
  ///
  /// Mapped to the `background-color` JSON key. Accepts any CSS-compatible
  /// hex color. Transparency can be set independently on the fill.
  @JsonKey(name: 'background-color')
  String get backgroundColor;

  /// Create a copy of MateoMapLibreStyleBackgroundPaint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleBackgroundPaintCopyWith<MateoMapLibreStyleBackgroundPaint>
  get copyWith =>
      _$MateoMapLibreStyleBackgroundPaintCopyWithImpl<
        MateoMapLibreStyleBackgroundPaint
      >(this as MateoMapLibreStyleBackgroundPaint, _$identity);

  /// Serializes this MateoMapLibreStyleBackgroundPaint to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyleBackgroundPaint &&
            (identical(other.backgroundColor, backgroundColor) ||
                other.backgroundColor == backgroundColor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, backgroundColor);

  @override
  String toString() {
    return 'MateoMapLibreStyleBackgroundPaint(backgroundColor: $backgroundColor)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleBackgroundPaintCopyWith<$Res> {
  factory $MateoMapLibreStyleBackgroundPaintCopyWith(
    MateoMapLibreStyleBackgroundPaint value,
    $Res Function(MateoMapLibreStyleBackgroundPaint) _then,
  ) = _$MateoMapLibreStyleBackgroundPaintCopyWithImpl;
  @useResult
  $Res call({@JsonKey(name: 'background-color') String backgroundColor});
}

/// @nodoc
class _$MateoMapLibreStyleBackgroundPaintCopyWithImpl<$Res>
    implements $MateoMapLibreStyleBackgroundPaintCopyWith<$Res> {
  _$MateoMapLibreStyleBackgroundPaintCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyleBackgroundPaint _self;
  final $Res Function(MateoMapLibreStyleBackgroundPaint) _then;

  /// Create a copy of MateoMapLibreStyleBackgroundPaint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? backgroundColor = null}) {
    return _then(
      _self.copyWith(
        backgroundColor: null == backgroundColor
            ? _self.backgroundColor
            : backgroundColor // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [MateoMapLibreStyleBackgroundPaint].
extension MateoMapLibreStyleBackgroundPaintPatterns
    on MateoMapLibreStyleBackgroundPaint {
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
    TResult Function(_MateoMapLibreStyleBackgroundPaint value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleBackgroundPaint() when $default != null:
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
    TResult Function(_MateoMapLibreStyleBackgroundPaint value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleBackgroundPaint():
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
    TResult? Function(_MateoMapLibreStyleBackgroundPaint value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleBackgroundPaint() when $default != null:
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
    TResult Function(@JsonKey(name: 'background-color') String backgroundColor)?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleBackgroundPaint() when $default != null:
        return $default(_that.backgroundColor);
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
    TResult Function(@JsonKey(name: 'background-color') String backgroundColor)
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleBackgroundPaint():
        return $default(_that.backgroundColor);
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
      @JsonKey(name: 'background-color') String backgroundColor,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleBackgroundPaint() when $default != null:
        return $default(_that.backgroundColor);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable(createFactory: false)
class _MateoMapLibreStyleBackgroundPaint
    implements MateoMapLibreStyleBackgroundPaint {
  const _MateoMapLibreStyleBackgroundPaint({
    @JsonKey(name: 'background-color') required this.backgroundColor,
  });

  /// The background fill color as a hex string (e.g. `"#ebedef"`).
  ///
  /// Mapped to the `background-color` JSON key. Accepts any CSS-compatible
  /// hex color. Transparency can be set independently on the fill.
  @override
  @JsonKey(name: 'background-color')
  final String backgroundColor;

  /// Create a copy of MateoMapLibreStyleBackgroundPaint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MateoMapLibreStyleBackgroundPaintCopyWith<
    _MateoMapLibreStyleBackgroundPaint
  >
  get copyWith =>
      __$MateoMapLibreStyleBackgroundPaintCopyWithImpl<
        _MateoMapLibreStyleBackgroundPaint
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MateoMapLibreStyleBackgroundPaintToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MateoMapLibreStyleBackgroundPaint &&
            (identical(other.backgroundColor, backgroundColor) ||
                other.backgroundColor == backgroundColor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, backgroundColor);

  @override
  String toString() {
    return 'MateoMapLibreStyleBackgroundPaint(backgroundColor: $backgroundColor)';
  }
}

/// @nodoc
abstract mixin class _$MateoMapLibreStyleBackgroundPaintCopyWith<$Res>
    implements $MateoMapLibreStyleBackgroundPaintCopyWith<$Res> {
  factory _$MateoMapLibreStyleBackgroundPaintCopyWith(
    _MateoMapLibreStyleBackgroundPaint value,
    $Res Function(_MateoMapLibreStyleBackgroundPaint) _then,
  ) = __$MateoMapLibreStyleBackgroundPaintCopyWithImpl;
  @override
  @useResult
  $Res call({@JsonKey(name: 'background-color') String backgroundColor});
}

/// @nodoc
class __$MateoMapLibreStyleBackgroundPaintCopyWithImpl<$Res>
    implements _$MateoMapLibreStyleBackgroundPaintCopyWith<$Res> {
  __$MateoMapLibreStyleBackgroundPaintCopyWithImpl(this._self, this._then);

  final _MateoMapLibreStyleBackgroundPaint _self;
  final $Res Function(_MateoMapLibreStyleBackgroundPaint) _then;

  /// Create a copy of MateoMapLibreStyleBackgroundPaint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? backgroundColor = null}) {
    return _then(
      _MateoMapLibreStyleBackgroundPaint(
        backgroundColor: null == backgroundColor
            ? _self.backgroundColor
            : backgroundColor // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
