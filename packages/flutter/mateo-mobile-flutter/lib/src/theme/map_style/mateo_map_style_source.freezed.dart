// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mateo_map_style_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MateoMapLibreStyleSource {
  /// The source type. Must be `"vector"` for vector tile sources.
  String get type;

  /// List of tile URL templates.
  ///
  /// Each template may contain `{x}`, `{y}`, `{z}` placeholders for tile
  /// coordinates, and a custom placeholder like `{tileUrlTemplate}` that
  /// is resolved at runtime via [MateoMapLibreStyle.light].
  List<String> get tiles;

  /// Minimum zoom level for which tiles are available.
  int get minzoom;

  /// Maximum zoom level for which tiles are available.
  int get maxzoom;

  /// Create a copy of MateoMapLibreStyleSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleSourceCopyWith<MateoMapLibreStyleSource> get copyWith =>
      _$MateoMapLibreStyleSourceCopyWithImpl<MateoMapLibreStyleSource>(
        this as MateoMapLibreStyleSource,
        _$identity,
      );

  /// Serializes this MateoMapLibreStyleSource to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyleSource &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other.tiles, tiles) &&
            (identical(other.minzoom, minzoom) || other.minzoom == minzoom) &&
            (identical(other.maxzoom, maxzoom) || other.maxzoom == maxzoom));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    const DeepCollectionEquality().hash(tiles),
    minzoom,
    maxzoom,
  );

  @override
  String toString() {
    return 'MateoMapLibreStyleSource(type: $type, tiles: $tiles, minzoom: $minzoom, maxzoom: $maxzoom)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleSourceCopyWith<$Res> {
  factory $MateoMapLibreStyleSourceCopyWith(
    MateoMapLibreStyleSource value,
    $Res Function(MateoMapLibreStyleSource) _then,
  ) = _$MateoMapLibreStyleSourceCopyWithImpl;
  @useResult
  $Res call({String type, List<String> tiles, int minzoom, int maxzoom});
}

/// @nodoc
class _$MateoMapLibreStyleSourceCopyWithImpl<$Res>
    implements $MateoMapLibreStyleSourceCopyWith<$Res> {
  _$MateoMapLibreStyleSourceCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyleSource _self;
  final $Res Function(MateoMapLibreStyleSource) _then;

  /// Create a copy of MateoMapLibreStyleSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? tiles = null,
    Object? minzoom = null,
    Object? maxzoom = null,
  }) {
    return _then(
      _self.copyWith(
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        tiles: null == tiles
            ? _self.tiles
            : tiles // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        minzoom: null == minzoom
            ? _self.minzoom
            : minzoom // ignore: cast_nullable_to_non_nullable
                  as int,
        maxzoom: null == maxzoom
            ? _self.maxzoom
            : maxzoom // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [MateoMapLibreStyleSource].
extension MateoMapLibreStyleSourcePatterns on MateoMapLibreStyleSource {
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
    TResult Function(_MateoMapLibreStyleSource value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSource() when $default != null:
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
    TResult Function(_MateoMapLibreStyleSource value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSource():
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
    TResult? Function(_MateoMapLibreStyleSource value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSource() when $default != null:
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
    TResult Function(String type, List<String> tiles, int minzoom, int maxzoom)?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSource() when $default != null:
        return $default(_that.type, _that.tiles, _that.minzoom, _that.maxzoom);
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
    TResult Function(String type, List<String> tiles, int minzoom, int maxzoom)
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSource():
        return $default(_that.type, _that.tiles, _that.minzoom, _that.maxzoom);
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
      String type,
      List<String> tiles,
      int minzoom,
      int maxzoom,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSource() when $default != null:
        return $default(_that.type, _that.tiles, _that.minzoom, _that.maxzoom);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable(createFactory: false)
class _MateoMapLibreStyleSource implements MateoMapLibreStyleSource {
  const _MateoMapLibreStyleSource({
    required this.type,
    required final List<String> tiles,
    required this.minzoom,
    required this.maxzoom,
  }) : _tiles = tiles;

  /// The source type. Must be `"vector"` for vector tile sources.
  @override
  final String type;

  /// List of tile URL templates.
  ///
  /// Each template may contain `{x}`, `{y}`, `{z}` placeholders for tile
  /// coordinates, and a custom placeholder like `{tileUrlTemplate}` that
  /// is resolved at runtime via [MateoMapLibreStyle.light].
  final List<String> _tiles;

  /// List of tile URL templates.
  ///
  /// Each template may contain `{x}`, `{y}`, `{z}` placeholders for tile
  /// coordinates, and a custom placeholder like `{tileUrlTemplate}` that
  /// is resolved at runtime via [MateoMapLibreStyle.light].
  @override
  List<String> get tiles {
    if (_tiles is EqualUnmodifiableListView) return _tiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tiles);
  }

  /// Minimum zoom level for which tiles are available.
  @override
  final int minzoom;

  /// Maximum zoom level for which tiles are available.
  @override
  final int maxzoom;

  /// Create a copy of MateoMapLibreStyleSource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MateoMapLibreStyleSourceCopyWith<_MateoMapLibreStyleSource> get copyWith =>
      __$MateoMapLibreStyleSourceCopyWithImpl<_MateoMapLibreStyleSource>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$MateoMapLibreStyleSourceToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MateoMapLibreStyleSource &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._tiles, _tiles) &&
            (identical(other.minzoom, minzoom) || other.minzoom == minzoom) &&
            (identical(other.maxzoom, maxzoom) || other.maxzoom == maxzoom));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    const DeepCollectionEquality().hash(_tiles),
    minzoom,
    maxzoom,
  );

  @override
  String toString() {
    return 'MateoMapLibreStyleSource(type: $type, tiles: $tiles, minzoom: $minzoom, maxzoom: $maxzoom)';
  }
}

/// @nodoc
abstract mixin class _$MateoMapLibreStyleSourceCopyWith<$Res>
    implements $MateoMapLibreStyleSourceCopyWith<$Res> {
  factory _$MateoMapLibreStyleSourceCopyWith(
    _MateoMapLibreStyleSource value,
    $Res Function(_MateoMapLibreStyleSource) _then,
  ) = __$MateoMapLibreStyleSourceCopyWithImpl;
  @override
  @useResult
  $Res call({String type, List<String> tiles, int minzoom, int maxzoom});
}

/// @nodoc
class __$MateoMapLibreStyleSourceCopyWithImpl<$Res>
    implements _$MateoMapLibreStyleSourceCopyWith<$Res> {
  __$MateoMapLibreStyleSourceCopyWithImpl(this._self, this._then);

  final _MateoMapLibreStyleSource _self;
  final $Res Function(_MateoMapLibreStyleSource) _then;

  /// Create a copy of MateoMapLibreStyleSource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? tiles = null,
    Object? minzoom = null,
    Object? maxzoom = null,
  }) {
    return _then(
      _MateoMapLibreStyleSource(
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        tiles: null == tiles
            ? _self._tiles
            : tiles // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        minzoom: null == minzoom
            ? _self.minzoom
            : minzoom // ignore: cast_nullable_to_non_nullable
                  as int,
        maxzoom: null == maxzoom
            ? _self.maxzoom
            : maxzoom // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
