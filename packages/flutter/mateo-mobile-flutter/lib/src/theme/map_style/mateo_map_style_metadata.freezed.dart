// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mateo_map_style_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MateoMapLibreStyleMetadata {
  /// Whether Mapbox GL can auto-composite raster tiles.
  ///
  /// Mapped to the `mapbox:autocomposite` JSON key. Set to `false` for
  /// vector tile sources where compositing is handled by the renderer.
  @JsonKey(name: 'mapbox:autocomposite')
  bool get mapboxAutocomposite;

  /// The style type identifier.
  ///
  /// Mapped to the `mapbox:type` JSON key. `"template"` indicates this is a
  /// base style designed to be extended or modified at consumption time.
  @JsonKey(name: 'mapbox:type')
  String get mapboxType;

  /// Mateo-specific style variant.
  ///
  /// Mapped to the `mateo:style` JSON key. Identifies the theme variant for
  /// debugging and asset auditing (e.g. `"light"`, `"dark"`).
  @JsonKey(name: 'mateo:style')
  String get mateoStyle;

  /// Create a copy of MateoMapLibreStyleMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleMetadataCopyWith<MateoMapLibreStyleMetadata>
  get copyWith =>
      _$MateoMapLibreStyleMetadataCopyWithImpl<MateoMapLibreStyleMetadata>(
        this as MateoMapLibreStyleMetadata,
        _$identity,
      );

  /// Serializes this MateoMapLibreStyleMetadata to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyleMetadata &&
            (identical(other.mapboxAutocomposite, mapboxAutocomposite) ||
                other.mapboxAutocomposite == mapboxAutocomposite) &&
            (identical(other.mapboxType, mapboxType) ||
                other.mapboxType == mapboxType) &&
            (identical(other.mateoStyle, mateoStyle) ||
                other.mateoStyle == mateoStyle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, mapboxAutocomposite, mapboxType, mateoStyle);

  @override
  String toString() {
    return 'MateoMapLibreStyleMetadata(mapboxAutocomposite: $mapboxAutocomposite, mapboxType: $mapboxType, mateoStyle: $mateoStyle)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleMetadataCopyWith<$Res> {
  factory $MateoMapLibreStyleMetadataCopyWith(
    MateoMapLibreStyleMetadata value,
    $Res Function(MateoMapLibreStyleMetadata) _then,
  ) = _$MateoMapLibreStyleMetadataCopyWithImpl;
  @useResult
  $Res call({
    @JsonKey(name: 'mapbox:autocomposite') bool mapboxAutocomposite,
    @JsonKey(name: 'mapbox:type') String mapboxType,
    @JsonKey(name: 'mateo:style') String mateoStyle,
  });
}

/// @nodoc
class _$MateoMapLibreStyleMetadataCopyWithImpl<$Res>
    implements $MateoMapLibreStyleMetadataCopyWith<$Res> {
  _$MateoMapLibreStyleMetadataCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyleMetadata _self;
  final $Res Function(MateoMapLibreStyleMetadata) _then;

  /// Create a copy of MateoMapLibreStyleMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapboxAutocomposite = null,
    Object? mapboxType = null,
    Object? mateoStyle = null,
  }) {
    return _then(
      _self.copyWith(
        mapboxAutocomposite: null == mapboxAutocomposite
            ? _self.mapboxAutocomposite
            : mapboxAutocomposite // ignore: cast_nullable_to_non_nullable
                  as bool,
        mapboxType: null == mapboxType
            ? _self.mapboxType
            : mapboxType // ignore: cast_nullable_to_non_nullable
                  as String,
        mateoStyle: null == mateoStyle
            ? _self.mateoStyle
            : mateoStyle // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [MateoMapLibreStyleMetadata].
extension MateoMapLibreStyleMetadataPatterns on MateoMapLibreStyleMetadata {
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
    TResult Function(_MateoMapLibreStyleMetadata value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleMetadata() when $default != null:
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
    TResult Function(_MateoMapLibreStyleMetadata value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleMetadata():
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
    TResult? Function(_MateoMapLibreStyleMetadata value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleMetadata() when $default != null:
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
      @JsonKey(name: 'mapbox:autocomposite') bool mapboxAutocomposite,
      @JsonKey(name: 'mapbox:type') String mapboxType,
      @JsonKey(name: 'mateo:style') String mateoStyle,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleMetadata() when $default != null:
        return $default(
          _that.mapboxAutocomposite,
          _that.mapboxType,
          _that.mateoStyle,
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
      @JsonKey(name: 'mapbox:autocomposite') bool mapboxAutocomposite,
      @JsonKey(name: 'mapbox:type') String mapboxType,
      @JsonKey(name: 'mateo:style') String mateoStyle,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleMetadata():
        return $default(
          _that.mapboxAutocomposite,
          _that.mapboxType,
          _that.mateoStyle,
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
      @JsonKey(name: 'mapbox:autocomposite') bool mapboxAutocomposite,
      @JsonKey(name: 'mapbox:type') String mapboxType,
      @JsonKey(name: 'mateo:style') String mateoStyle,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleMetadata() when $default != null:
        return $default(
          _that.mapboxAutocomposite,
          _that.mapboxType,
          _that.mateoStyle,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable(createFactory: false)
class _MateoMapLibreStyleMetadata implements MateoMapLibreStyleMetadata {
  const _MateoMapLibreStyleMetadata({
    @JsonKey(name: 'mapbox:autocomposite') required this.mapboxAutocomposite,
    @JsonKey(name: 'mapbox:type') required this.mapboxType,
    @JsonKey(name: 'mateo:style') required this.mateoStyle,
  });

  /// Whether Mapbox GL can auto-composite raster tiles.
  ///
  /// Mapped to the `mapbox:autocomposite` JSON key. Set to `false` for
  /// vector tile sources where compositing is handled by the renderer.
  @override
  @JsonKey(name: 'mapbox:autocomposite')
  final bool mapboxAutocomposite;

  /// The style type identifier.
  ///
  /// Mapped to the `mapbox:type` JSON key. `"template"` indicates this is a
  /// base style designed to be extended or modified at consumption time.
  @override
  @JsonKey(name: 'mapbox:type')
  final String mapboxType;

  /// Mateo-specific style variant.
  ///
  /// Mapped to the `mateo:style` JSON key. Identifies the theme variant for
  /// debugging and asset auditing (e.g. `"light"`, `"dark"`).
  @override
  @JsonKey(name: 'mateo:style')
  final String mateoStyle;

  /// Create a copy of MateoMapLibreStyleMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MateoMapLibreStyleMetadataCopyWith<_MateoMapLibreStyleMetadata>
  get copyWith =>
      __$MateoMapLibreStyleMetadataCopyWithImpl<_MateoMapLibreStyleMetadata>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$MateoMapLibreStyleMetadataToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MateoMapLibreStyleMetadata &&
            (identical(other.mapboxAutocomposite, mapboxAutocomposite) ||
                other.mapboxAutocomposite == mapboxAutocomposite) &&
            (identical(other.mapboxType, mapboxType) ||
                other.mapboxType == mapboxType) &&
            (identical(other.mateoStyle, mateoStyle) ||
                other.mateoStyle == mateoStyle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, mapboxAutocomposite, mapboxType, mateoStyle);

  @override
  String toString() {
    return 'MateoMapLibreStyleMetadata(mapboxAutocomposite: $mapboxAutocomposite, mapboxType: $mapboxType, mateoStyle: $mateoStyle)';
  }
}

/// @nodoc
abstract mixin class _$MateoMapLibreStyleMetadataCopyWith<$Res>
    implements $MateoMapLibreStyleMetadataCopyWith<$Res> {
  factory _$MateoMapLibreStyleMetadataCopyWith(
    _MateoMapLibreStyleMetadata value,
    $Res Function(_MateoMapLibreStyleMetadata) _then,
  ) = __$MateoMapLibreStyleMetadataCopyWithImpl;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'mapbox:autocomposite') bool mapboxAutocomposite,
    @JsonKey(name: 'mapbox:type') String mapboxType,
    @JsonKey(name: 'mateo:style') String mateoStyle,
  });
}

/// @nodoc
class __$MateoMapLibreStyleMetadataCopyWithImpl<$Res>
    implements _$MateoMapLibreStyleMetadataCopyWith<$Res> {
  __$MateoMapLibreStyleMetadataCopyWithImpl(this._self, this._then);

  final _MateoMapLibreStyleMetadata _self;
  final $Res Function(_MateoMapLibreStyleMetadata) _then;

  /// Create a copy of MateoMapLibreStyleMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mapboxAutocomposite = null,
    Object? mapboxType = null,
    Object? mateoStyle = null,
  }) {
    return _then(
      _MateoMapLibreStyleMetadata(
        mapboxAutocomposite: null == mapboxAutocomposite
            ? _self.mapboxAutocomposite
            : mapboxAutocomposite // ignore: cast_nullable_to_non_nullable
                  as bool,
        mapboxType: null == mapboxType
            ? _self.mapboxType
            : mapboxType // ignore: cast_nullable_to_non_nullable
                  as String,
        mateoStyle: null == mateoStyle
            ? _self.mateoStyle
            : mateoStyle // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
