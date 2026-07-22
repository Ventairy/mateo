// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mateo_map_style.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MateoMapLibreStyle {
  int get version;
  String get id;
  String get name;
  String get glyphs;
  MateoMapLibreStyleMetadata get metadata;
  Map<String, MateoMapLibreStyleSource> get sources;
  @MateoMapLibreStyleLayerConverter()
  List<MateoMapLibreStyleLayer> get layers;

  /// Create a copy of MateoMapLibreStyle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleCopyWith<MateoMapLibreStyle> get copyWith =>
      _$MateoMapLibreStyleCopyWithImpl<MateoMapLibreStyle>(
        this as MateoMapLibreStyle,
        _$identity,
      );

  /// Serializes this MateoMapLibreStyle to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyle &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.glyphs, glyphs) || other.glyphs == glyphs) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            const DeepCollectionEquality().equals(other.sources, sources) &&
            const DeepCollectionEquality().equals(other.layers, layers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    version,
    id,
    name,
    glyphs,
    metadata,
    const DeepCollectionEquality().hash(sources),
    const DeepCollectionEquality().hash(layers),
  );

  @override
  String toString() {
    return 'MateoMapLibreStyle(version: $version, id: $id, name: $name, glyphs: $glyphs, metadata: $metadata, sources: $sources, layers: $layers)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleCopyWith<$Res> {
  factory $MateoMapLibreStyleCopyWith(
    MateoMapLibreStyle value,
    $Res Function(MateoMapLibreStyle) _then,
  ) = _$MateoMapLibreStyleCopyWithImpl;
  @useResult
  $Res call({
    int version,
    String id,
    String name,
    String glyphs,
    MateoMapLibreStyleMetadata metadata,
    Map<String, MateoMapLibreStyleSource> sources,
    @MateoMapLibreStyleLayerConverter() List<MateoMapLibreStyleLayer> layers,
  });

  $MateoMapLibreStyleMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class _$MateoMapLibreStyleCopyWithImpl<$Res>
    implements $MateoMapLibreStyleCopyWith<$Res> {
  _$MateoMapLibreStyleCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyle _self;
  final $Res Function(MateoMapLibreStyle) _then;

  /// Create a copy of MateoMapLibreStyle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? id = null,
    Object? name = null,
    Object? glyphs = null,
    Object? metadata = null,
    Object? sources = null,
    Object? layers = null,
  }) {
    return _then(
      _self.copyWith(
        version: null == version
            ? _self.version
            : version // ignore: cast_nullable_to_non_nullable
                  as int,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        glyphs: null == glyphs
            ? _self.glyphs
            : glyphs // ignore: cast_nullable_to_non_nullable
                  as String,
        metadata: null == metadata
            ? _self.metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as MateoMapLibreStyleMetadata,
        sources: null == sources
            ? _self.sources
            : sources // ignore: cast_nullable_to_non_nullable
                  as Map<String, MateoMapLibreStyleSource>,
        layers: null == layers
            ? _self.layers
            : layers // ignore: cast_nullable_to_non_nullable
                  as List<MateoMapLibreStyleLayer>,
      ),
    );
  }

  /// Create a copy of MateoMapLibreStyle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleMetadataCopyWith<$Res> get metadata {
    return $MateoMapLibreStyleMetadataCopyWith<$Res>(_self.metadata, (value) {
      return _then(_self.copyWith(metadata: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MateoMapLibreStyle].
extension MateoMapLibreStylePatterns on MateoMapLibreStyle {
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
    TResult Function(_MateoMapLibreStyle value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyle() when $default != null:
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
    TResult Function(_MateoMapLibreStyle value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyle():
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
    TResult? Function(_MateoMapLibreStyle value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyle() when $default != null:
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
      int version,
      String id,
      String name,
      String glyphs,
      MateoMapLibreStyleMetadata metadata,
      Map<String, MateoMapLibreStyleSource> sources,
      @MateoMapLibreStyleLayerConverter() List<MateoMapLibreStyleLayer> layers,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyle() when $default != null:
        return $default(
          _that.version,
          _that.id,
          _that.name,
          _that.glyphs,
          _that.metadata,
          _that.sources,
          _that.layers,
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
      int version,
      String id,
      String name,
      String glyphs,
      MateoMapLibreStyleMetadata metadata,
      Map<String, MateoMapLibreStyleSource> sources,
      @MateoMapLibreStyleLayerConverter() List<MateoMapLibreStyleLayer> layers,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyle():
        return $default(
          _that.version,
          _that.id,
          _that.name,
          _that.glyphs,
          _that.metadata,
          _that.sources,
          _that.layers,
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
      int version,
      String id,
      String name,
      String glyphs,
      MateoMapLibreStyleMetadata metadata,
      Map<String, MateoMapLibreStyleSource> sources,
      @MateoMapLibreStyleLayerConverter() List<MateoMapLibreStyleLayer> layers,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyle() when $default != null:
        return $default(
          _that.version,
          _that.id,
          _that.name,
          _that.glyphs,
          _that.metadata,
          _that.sources,
          _that.layers,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable(createFactory: false)
class _MateoMapLibreStyle implements MateoMapLibreStyle {
  const _MateoMapLibreStyle({
    required this.version,
    required this.id,
    required this.name,
    required this.glyphs,
    required this.metadata,
    required final Map<String, MateoMapLibreStyleSource> sources,
    @MateoMapLibreStyleLayerConverter()
    required final List<MateoMapLibreStyleLayer> layers,
  }) : _sources = sources,
       _layers = layers;

  @override
  final int version;
  @override
  final String id;
  @override
  final String name;
  @override
  final String glyphs;
  @override
  final MateoMapLibreStyleMetadata metadata;
  final Map<String, MateoMapLibreStyleSource> _sources;
  @override
  Map<String, MateoMapLibreStyleSource> get sources {
    if (_sources is EqualUnmodifiableMapView) return _sources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_sources);
  }

  final List<MateoMapLibreStyleLayer> _layers;
  @override
  @MateoMapLibreStyleLayerConverter()
  List<MateoMapLibreStyleLayer> get layers {
    if (_layers is EqualUnmodifiableListView) return _layers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_layers);
  }

  /// Create a copy of MateoMapLibreStyle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MateoMapLibreStyleCopyWith<_MateoMapLibreStyle> get copyWith =>
      __$MateoMapLibreStyleCopyWithImpl<_MateoMapLibreStyle>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MateoMapLibreStyleToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MateoMapLibreStyle &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.glyphs, glyphs) || other.glyphs == glyphs) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            const DeepCollectionEquality().equals(other._sources, _sources) &&
            const DeepCollectionEquality().equals(other._layers, _layers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    version,
    id,
    name,
    glyphs,
    metadata,
    const DeepCollectionEquality().hash(_sources),
    const DeepCollectionEquality().hash(_layers),
  );

  @override
  String toString() {
    return 'MateoMapLibreStyle(version: $version, id: $id, name: $name, glyphs: $glyphs, metadata: $metadata, sources: $sources, layers: $layers)';
  }
}

/// @nodoc
abstract mixin class _$MateoMapLibreStyleCopyWith<$Res>
    implements $MateoMapLibreStyleCopyWith<$Res> {
  factory _$MateoMapLibreStyleCopyWith(
    _MateoMapLibreStyle value,
    $Res Function(_MateoMapLibreStyle) _then,
  ) = __$MateoMapLibreStyleCopyWithImpl;
  @override
  @useResult
  $Res call({
    int version,
    String id,
    String name,
    String glyphs,
    MateoMapLibreStyleMetadata metadata,
    Map<String, MateoMapLibreStyleSource> sources,
    @MateoMapLibreStyleLayerConverter() List<MateoMapLibreStyleLayer> layers,
  });

  @override
  $MateoMapLibreStyleMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class __$MateoMapLibreStyleCopyWithImpl<$Res>
    implements _$MateoMapLibreStyleCopyWith<$Res> {
  __$MateoMapLibreStyleCopyWithImpl(this._self, this._then);

  final _MateoMapLibreStyle _self;
  final $Res Function(_MateoMapLibreStyle) _then;

  /// Create a copy of MateoMapLibreStyle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? version = null,
    Object? id = null,
    Object? name = null,
    Object? glyphs = null,
    Object? metadata = null,
    Object? sources = null,
    Object? layers = null,
  }) {
    return _then(
      _MateoMapLibreStyle(
        version: null == version
            ? _self.version
            : version // ignore: cast_nullable_to_non_nullable
                  as int,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        glyphs: null == glyphs
            ? _self.glyphs
            : glyphs // ignore: cast_nullable_to_non_nullable
                  as String,
        metadata: null == metadata
            ? _self.metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as MateoMapLibreStyleMetadata,
        sources: null == sources
            ? _self._sources
            : sources // ignore: cast_nullable_to_non_nullable
                  as Map<String, MateoMapLibreStyleSource>,
        layers: null == layers
            ? _self._layers
            : layers // ignore: cast_nullable_to_non_nullable
                  as List<MateoMapLibreStyleLayer>,
      ),
    );
  }

  /// Create a copy of MateoMapLibreStyle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleMetadataCopyWith<$Res> get metadata {
    return $MateoMapLibreStyleMetadataCopyWith<$Res>(_self.metadata, (value) {
      return _then(_self.copyWith(metadata: value));
    });
  }
}
