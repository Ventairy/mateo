// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mateo_map_style_layer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MateoMapLibreStyleLayer {
  String get id;
  Object get paint;

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleLayerCopyWith<MateoMapLibreStyleLayer> get copyWith =>
      _$MateoMapLibreStyleLayerCopyWithImpl<MateoMapLibreStyleLayer>(
        this as MateoMapLibreStyleLayer,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyleLayer &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.paint, paint));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, const DeepCollectionEquality().hash(paint));

  @override
  String toString() {
    return 'MateoMapLibreStyleLayer(id: $id, paint: $paint)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleLayerCopyWith<$Res> {
  factory $MateoMapLibreStyleLayerCopyWith(
    MateoMapLibreStyleLayer value,
    $Res Function(MateoMapLibreStyleLayer) _then,
  ) = _$MateoMapLibreStyleLayerCopyWithImpl;
  @useResult
  $Res call({String id});
}

/// @nodoc
class _$MateoMapLibreStyleLayerCopyWithImpl<$Res>
    implements $MateoMapLibreStyleLayerCopyWith<$Res> {
  _$MateoMapLibreStyleLayerCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyleLayer _self;
  final $Res Function(MateoMapLibreStyleLayer) _then;

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [MateoMapLibreStyleLayer].
extension MateoMapLibreStyleLayerPatterns on MateoMapLibreStyleLayer {
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
    TResult Function(MateoMapBackgroundLayer value)? background,
    TResult Function(MateoMapFillLayer value)? fill,
    TResult Function(MateoMapLineLayer value)? line,
    TResult Function(MateoMapSymbolLayer value)? symbol,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapBackgroundLayer() when background != null:
        return background(_that);
      case MateoMapFillLayer() when fill != null:
        return fill(_that);
      case MateoMapLineLayer() when line != null:
        return line(_that);
      case MateoMapSymbolLayer() when symbol != null:
        return symbol(_that);
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
    required TResult Function(MateoMapBackgroundLayer value) background,
    required TResult Function(MateoMapFillLayer value) fill,
    required TResult Function(MateoMapLineLayer value) line,
    required TResult Function(MateoMapSymbolLayer value) symbol,
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapBackgroundLayer():
        return background(_that);
      case MateoMapFillLayer():
        return fill(_that);
      case MateoMapLineLayer():
        return line(_that);
      case MateoMapSymbolLayer():
        return symbol(_that);
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
    TResult? Function(MateoMapBackgroundLayer value)? background,
    TResult? Function(MateoMapFillLayer value)? fill,
    TResult? Function(MateoMapLineLayer value)? line,
    TResult? Function(MateoMapSymbolLayer value)? symbol,
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapBackgroundLayer() when background != null:
        return background(_that);
      case MateoMapFillLayer() when fill != null:
        return fill(_that);
      case MateoMapLineLayer() when line != null:
        return line(_that);
      case MateoMapSymbolLayer() when symbol != null:
        return symbol(_that);
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
    TResult Function(String id, MateoMapLibreStyleBackgroundPaint paint)?
    background,
    TResult Function(
      String id,
      MateoMapLibreStyleFillPaint paint,
      String? source,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      MateoMapLibreStyleFilter? filter,
    )?
    fill,
    TResult Function(
      String id,
      MateoMapLibreStyleLinePaint paint,
      String? source,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      MateoMapLibreStyleFilter? filter,
    )?
    line,
    TResult Function(
      String id,
      MateoMapLibreStyleSymbolPaint paint,
      String? source,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      MateoMapLibreStyleFilter? filter,
      MateoMapLibreStyleSymbolLayout? layout,
    )?
    symbol,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapBackgroundLayer() when background != null:
        return background(_that.id, _that.paint);
      case MateoMapFillLayer() when fill != null:
        return fill(
          _that.id,
          _that.paint,
          _that.source,
          _that.sourceLayer,
          _that.minzoom,
          _that.maxzoom,
          _that.filter,
        );
      case MateoMapLineLayer() when line != null:
        return line(
          _that.id,
          _that.paint,
          _that.source,
          _that.sourceLayer,
          _that.minzoom,
          _that.maxzoom,
          _that.filter,
        );
      case MateoMapSymbolLayer() when symbol != null:
        return symbol(
          _that.id,
          _that.paint,
          _that.source,
          _that.sourceLayer,
          _that.minzoom,
          _that.maxzoom,
          _that.filter,
          _that.layout,
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
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      MateoMapLibreStyleBackgroundPaint paint,
    )
    background,
    required TResult Function(
      String id,
      MateoMapLibreStyleFillPaint paint,
      String? source,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      MateoMapLibreStyleFilter? filter,
    )
    fill,
    required TResult Function(
      String id,
      MateoMapLibreStyleLinePaint paint,
      String? source,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      MateoMapLibreStyleFilter? filter,
    )
    line,
    required TResult Function(
      String id,
      MateoMapLibreStyleSymbolPaint paint,
      String? source,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      MateoMapLibreStyleFilter? filter,
      MateoMapLibreStyleSymbolLayout? layout,
    )
    symbol,
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapBackgroundLayer():
        return background(_that.id, _that.paint);
      case MateoMapFillLayer():
        return fill(
          _that.id,
          _that.paint,
          _that.source,
          _that.sourceLayer,
          _that.minzoom,
          _that.maxzoom,
          _that.filter,
        );
      case MateoMapLineLayer():
        return line(
          _that.id,
          _that.paint,
          _that.source,
          _that.sourceLayer,
          _that.minzoom,
          _that.maxzoom,
          _that.filter,
        );
      case MateoMapSymbolLayer():
        return symbol(
          _that.id,
          _that.paint,
          _that.source,
          _that.sourceLayer,
          _that.minzoom,
          _that.maxzoom,
          _that.filter,
          _that.layout,
        );
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
    TResult? Function(String id, MateoMapLibreStyleBackgroundPaint paint)?
    background,
    TResult? Function(
      String id,
      MateoMapLibreStyleFillPaint paint,
      String? source,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      MateoMapLibreStyleFilter? filter,
    )?
    fill,
    TResult? Function(
      String id,
      MateoMapLibreStyleLinePaint paint,
      String? source,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      MateoMapLibreStyleFilter? filter,
    )?
    line,
    TResult? Function(
      String id,
      MateoMapLibreStyleSymbolPaint paint,
      String? source,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      MateoMapLibreStyleFilter? filter,
      MateoMapLibreStyleSymbolLayout? layout,
    )?
    symbol,
  }) {
    final _that = this;
    switch (_that) {
      case MateoMapBackgroundLayer() when background != null:
        return background(_that.id, _that.paint);
      case MateoMapFillLayer() when fill != null:
        return fill(
          _that.id,
          _that.paint,
          _that.source,
          _that.sourceLayer,
          _that.minzoom,
          _that.maxzoom,
          _that.filter,
        );
      case MateoMapLineLayer() when line != null:
        return line(
          _that.id,
          _that.paint,
          _that.source,
          _that.sourceLayer,
          _that.minzoom,
          _that.maxzoom,
          _that.filter,
        );
      case MateoMapSymbolLayer() when symbol != null:
        return symbol(
          _that.id,
          _that.paint,
          _that.source,
          _that.sourceLayer,
          _that.minzoom,
          _that.maxzoom,
          _that.filter,
          _that.layout,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc

class MateoMapBackgroundLayer implements MateoMapLibreStyleLayer {
  const MateoMapBackgroundLayer({required this.id, required this.paint});

  @override
  final String id;
  @override
  final MateoMapLibreStyleBackgroundPaint paint;

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapBackgroundLayerCopyWith<MateoMapBackgroundLayer> get copyWith =>
      _$MateoMapBackgroundLayerCopyWithImpl<MateoMapBackgroundLayer>(
        this,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapBackgroundLayer &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.paint, paint) || other.paint == paint));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, paint);

  @override
  String toString() {
    return 'MateoMapLibreStyleLayer.background(id: $id, paint: $paint)';
  }
}

/// @nodoc
abstract mixin class $MateoMapBackgroundLayerCopyWith<$Res>
    implements $MateoMapLibreStyleLayerCopyWith<$Res> {
  factory $MateoMapBackgroundLayerCopyWith(
    MateoMapBackgroundLayer value,
    $Res Function(MateoMapBackgroundLayer) _then,
  ) = _$MateoMapBackgroundLayerCopyWithImpl;
  @override
  @useResult
  $Res call({String id, MateoMapLibreStyleBackgroundPaint paint});

  $MateoMapLibreStyleBackgroundPaintCopyWith<$Res> get paint;
}

/// @nodoc
class _$MateoMapBackgroundLayerCopyWithImpl<$Res>
    implements $MateoMapBackgroundLayerCopyWith<$Res> {
  _$MateoMapBackgroundLayerCopyWithImpl(this._self, this._then);

  final MateoMapBackgroundLayer _self;
  final $Res Function(MateoMapBackgroundLayer) _then;

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? id = null, Object? paint = null}) {
    return _then(
      MateoMapBackgroundLayer(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        paint: null == paint
            ? _self.paint
            : paint // ignore: cast_nullable_to_non_nullable
                  as MateoMapLibreStyleBackgroundPaint,
      ),
    );
  }

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleBackgroundPaintCopyWith<$Res> get paint {
    return $MateoMapLibreStyleBackgroundPaintCopyWith<$Res>(_self.paint, (
      value,
    ) {
      return _then(_self.copyWith(paint: value));
    });
  }
}

/// @nodoc

class MateoMapFillLayer implements MateoMapLibreStyleLayer {
  const MateoMapFillLayer({
    required this.id,
    required this.paint,
    this.source,
    this.sourceLayer,
    this.minzoom,
    this.maxzoom,
    this.filter,
  });

  @override
  final String id;
  @override
  final MateoMapLibreStyleFillPaint paint;
  final String? source;
  final String? sourceLayer;
  final double? minzoom;
  final double? maxzoom;
  final MateoMapLibreStyleFilter? filter;

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapFillLayerCopyWith<MateoMapFillLayer> get copyWith =>
      _$MateoMapFillLayerCopyWithImpl<MateoMapFillLayer>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapFillLayer &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.paint, paint) || other.paint == paint) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.sourceLayer, sourceLayer) ||
                other.sourceLayer == sourceLayer) &&
            (identical(other.minzoom, minzoom) || other.minzoom == minzoom) &&
            (identical(other.maxzoom, maxzoom) || other.maxzoom == maxzoom) &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    paint,
    source,
    sourceLayer,
    minzoom,
    maxzoom,
    filter,
  );

  @override
  String toString() {
    return 'MateoMapLibreStyleLayer.fill(id: $id, paint: $paint, source: $source, sourceLayer: $sourceLayer, minzoom: $minzoom, maxzoom: $maxzoom, filter: $filter)';
  }
}

/// @nodoc
abstract mixin class $MateoMapFillLayerCopyWith<$Res>
    implements $MateoMapLibreStyleLayerCopyWith<$Res> {
  factory $MateoMapFillLayerCopyWith(
    MateoMapFillLayer value,
    $Res Function(MateoMapFillLayer) _then,
  ) = _$MateoMapFillLayerCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    MateoMapLibreStyleFillPaint paint,
    String? source,
    String? sourceLayer,
    double? minzoom,
    double? maxzoom,
    MateoMapLibreStyleFilter? filter,
  });

  $MateoMapLibreStyleFillPaintCopyWith<$Res> get paint;
  $MateoMapLibreStyleFilterCopyWith<$Res>? get filter;
}

/// @nodoc
class _$MateoMapFillLayerCopyWithImpl<$Res>
    implements $MateoMapFillLayerCopyWith<$Res> {
  _$MateoMapFillLayerCopyWithImpl(this._self, this._then);

  final MateoMapFillLayer _self;
  final $Res Function(MateoMapFillLayer) _then;

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? paint = null,
    Object? source = freezed,
    Object? sourceLayer = freezed,
    Object? minzoom = freezed,
    Object? maxzoom = freezed,
    Object? filter = freezed,
  }) {
    return _then(
      MateoMapFillLayer(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        paint: null == paint
            ? _self.paint
            : paint // ignore: cast_nullable_to_non_nullable
                  as MateoMapLibreStyleFillPaint,
        source: freezed == source
            ? _self.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String?,
        sourceLayer: freezed == sourceLayer
            ? _self.sourceLayer
            : sourceLayer // ignore: cast_nullable_to_non_nullable
                  as String?,
        minzoom: freezed == minzoom
            ? _self.minzoom
            : minzoom // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxzoom: freezed == maxzoom
            ? _self.maxzoom
            : maxzoom // ignore: cast_nullable_to_non_nullable
                  as double?,
        filter: freezed == filter
            ? _self.filter
            : filter // ignore: cast_nullable_to_non_nullable
                  as MateoMapLibreStyleFilter?,
      ),
    );
  }

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleFillPaintCopyWith<$Res> get paint {
    return $MateoMapLibreStyleFillPaintCopyWith<$Res>(_self.paint, (value) {
      return _then(_self.copyWith(paint: value));
    });
  }

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleFilterCopyWith<$Res>? get filter {
    if (_self.filter == null) {
      return null;
    }

    return $MateoMapLibreStyleFilterCopyWith<$Res>(_self.filter!, (value) {
      return _then(_self.copyWith(filter: value));
    });
  }
}

/// @nodoc

class MateoMapLineLayer implements MateoMapLibreStyleLayer {
  const MateoMapLineLayer({
    required this.id,
    required this.paint,
    this.source,
    this.sourceLayer,
    this.minzoom,
    this.maxzoom,
    this.filter,
  });

  @override
  final String id;
  @override
  final MateoMapLibreStyleLinePaint paint;
  final String? source;
  final String? sourceLayer;
  final double? minzoom;
  final double? maxzoom;
  final MateoMapLibreStyleFilter? filter;

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLineLayerCopyWith<MateoMapLineLayer> get copyWith =>
      _$MateoMapLineLayerCopyWithImpl<MateoMapLineLayer>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLineLayer &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.paint, paint) || other.paint == paint) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.sourceLayer, sourceLayer) ||
                other.sourceLayer == sourceLayer) &&
            (identical(other.minzoom, minzoom) || other.minzoom == minzoom) &&
            (identical(other.maxzoom, maxzoom) || other.maxzoom == maxzoom) &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    paint,
    source,
    sourceLayer,
    minzoom,
    maxzoom,
    filter,
  );

  @override
  String toString() {
    return 'MateoMapLibreStyleLayer.line(id: $id, paint: $paint, source: $source, sourceLayer: $sourceLayer, minzoom: $minzoom, maxzoom: $maxzoom, filter: $filter)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLineLayerCopyWith<$Res>
    implements $MateoMapLibreStyleLayerCopyWith<$Res> {
  factory $MateoMapLineLayerCopyWith(
    MateoMapLineLayer value,
    $Res Function(MateoMapLineLayer) _then,
  ) = _$MateoMapLineLayerCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    MateoMapLibreStyleLinePaint paint,
    String? source,
    String? sourceLayer,
    double? minzoom,
    double? maxzoom,
    MateoMapLibreStyleFilter? filter,
  });

  $MateoMapLibreStyleLinePaintCopyWith<$Res> get paint;
  $MateoMapLibreStyleFilterCopyWith<$Res>? get filter;
}

/// @nodoc
class _$MateoMapLineLayerCopyWithImpl<$Res>
    implements $MateoMapLineLayerCopyWith<$Res> {
  _$MateoMapLineLayerCopyWithImpl(this._self, this._then);

  final MateoMapLineLayer _self;
  final $Res Function(MateoMapLineLayer) _then;

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? paint = null,
    Object? source = freezed,
    Object? sourceLayer = freezed,
    Object? minzoom = freezed,
    Object? maxzoom = freezed,
    Object? filter = freezed,
  }) {
    return _then(
      MateoMapLineLayer(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        paint: null == paint
            ? _self.paint
            : paint // ignore: cast_nullable_to_non_nullable
                  as MateoMapLibreStyleLinePaint,
        source: freezed == source
            ? _self.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String?,
        sourceLayer: freezed == sourceLayer
            ? _self.sourceLayer
            : sourceLayer // ignore: cast_nullable_to_non_nullable
                  as String?,
        minzoom: freezed == minzoom
            ? _self.minzoom
            : minzoom // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxzoom: freezed == maxzoom
            ? _self.maxzoom
            : maxzoom // ignore: cast_nullable_to_non_nullable
                  as double?,
        filter: freezed == filter
            ? _self.filter
            : filter // ignore: cast_nullable_to_non_nullable
                  as MateoMapLibreStyleFilter?,
      ),
    );
  }

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleLinePaintCopyWith<$Res> get paint {
    return $MateoMapLibreStyleLinePaintCopyWith<$Res>(_self.paint, (value) {
      return _then(_self.copyWith(paint: value));
    });
  }

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleFilterCopyWith<$Res>? get filter {
    if (_self.filter == null) {
      return null;
    }

    return $MateoMapLibreStyleFilterCopyWith<$Res>(_self.filter!, (value) {
      return _then(_self.copyWith(filter: value));
    });
  }
}

/// @nodoc

class MateoMapSymbolLayer implements MateoMapLibreStyleLayer {
  const MateoMapSymbolLayer({
    required this.id,
    required this.paint,
    this.source,
    this.sourceLayer,
    this.minzoom,
    this.maxzoom,
    this.filter,
    this.layout,
  });

  @override
  final String id;
  @override
  final MateoMapLibreStyleSymbolPaint paint;
  final String? source;
  final String? sourceLayer;
  final double? minzoom;
  final double? maxzoom;
  final MateoMapLibreStyleFilter? filter;
  final MateoMapLibreStyleSymbolLayout? layout;

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapSymbolLayerCopyWith<MateoMapSymbolLayer> get copyWith =>
      _$MateoMapSymbolLayerCopyWithImpl<MateoMapSymbolLayer>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapSymbolLayer &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.paint, paint) || other.paint == paint) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.sourceLayer, sourceLayer) ||
                other.sourceLayer == sourceLayer) &&
            (identical(other.minzoom, minzoom) || other.minzoom == minzoom) &&
            (identical(other.maxzoom, maxzoom) || other.maxzoom == maxzoom) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.layout, layout) || other.layout == layout));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    paint,
    source,
    sourceLayer,
    minzoom,
    maxzoom,
    filter,
    layout,
  );

  @override
  String toString() {
    return 'MateoMapLibreStyleLayer.symbol(id: $id, paint: $paint, source: $source, sourceLayer: $sourceLayer, minzoom: $minzoom, maxzoom: $maxzoom, filter: $filter, layout: $layout)';
  }
}

/// @nodoc
abstract mixin class $MateoMapSymbolLayerCopyWith<$Res>
    implements $MateoMapLibreStyleLayerCopyWith<$Res> {
  factory $MateoMapSymbolLayerCopyWith(
    MateoMapSymbolLayer value,
    $Res Function(MateoMapSymbolLayer) _then,
  ) = _$MateoMapSymbolLayerCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    MateoMapLibreStyleSymbolPaint paint,
    String? source,
    String? sourceLayer,
    double? minzoom,
    double? maxzoom,
    MateoMapLibreStyleFilter? filter,
    MateoMapLibreStyleSymbolLayout? layout,
  });

  $MateoMapLibreStyleSymbolPaintCopyWith<$Res> get paint;
  $MateoMapLibreStyleFilterCopyWith<$Res>? get filter;
  $MateoMapLibreStyleSymbolLayoutCopyWith<$Res>? get layout;
}

/// @nodoc
class _$MateoMapSymbolLayerCopyWithImpl<$Res>
    implements $MateoMapSymbolLayerCopyWith<$Res> {
  _$MateoMapSymbolLayerCopyWithImpl(this._self, this._then);

  final MateoMapSymbolLayer _self;
  final $Res Function(MateoMapSymbolLayer) _then;

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? paint = null,
    Object? source = freezed,
    Object? sourceLayer = freezed,
    Object? minzoom = freezed,
    Object? maxzoom = freezed,
    Object? filter = freezed,
    Object? layout = freezed,
  }) {
    return _then(
      MateoMapSymbolLayer(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        paint: null == paint
            ? _self.paint
            : paint // ignore: cast_nullable_to_non_nullable
                  as MateoMapLibreStyleSymbolPaint,
        source: freezed == source
            ? _self.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String?,
        sourceLayer: freezed == sourceLayer
            ? _self.sourceLayer
            : sourceLayer // ignore: cast_nullable_to_non_nullable
                  as String?,
        minzoom: freezed == minzoom
            ? _self.minzoom
            : minzoom // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxzoom: freezed == maxzoom
            ? _self.maxzoom
            : maxzoom // ignore: cast_nullable_to_non_nullable
                  as double?,
        filter: freezed == filter
            ? _self.filter
            : filter // ignore: cast_nullable_to_non_nullable
                  as MateoMapLibreStyleFilter?,
        layout: freezed == layout
            ? _self.layout
            : layout // ignore: cast_nullable_to_non_nullable
                  as MateoMapLibreStyleSymbolLayout?,
      ),
    );
  }

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleSymbolPaintCopyWith<$Res> get paint {
    return $MateoMapLibreStyleSymbolPaintCopyWith<$Res>(_self.paint, (value) {
      return _then(_self.copyWith(paint: value));
    });
  }

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleFilterCopyWith<$Res>? get filter {
    if (_self.filter == null) {
      return null;
    }

    return $MateoMapLibreStyleFilterCopyWith<$Res>(_self.filter!, (value) {
      return _then(_self.copyWith(filter: value));
    });
  }

  /// Create a copy of MateoMapLibreStyleLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleSymbolLayoutCopyWith<$Res>? get layout {
    if (_self.layout == null) {
      return null;
    }

    return $MateoMapLibreStyleSymbolLayoutCopyWith<$Res>(_self.layout!, (
      value,
    ) {
      return _then(_self.copyWith(layout: value));
    });
  }
}
