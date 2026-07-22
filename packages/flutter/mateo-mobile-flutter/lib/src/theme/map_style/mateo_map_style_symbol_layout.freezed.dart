// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mateo_map_style_symbol_layout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MateoMapLibreStyleSymbolLayout {
  /// The text content expression (e.g. `"{name}"` to use a feature property).
  ///
  /// Mapped to the `text-field` JSON key. Accepts a field reference (in
  /// curly braces) or a string literal. When null, no text is rendered.
  @JsonKey(name: 'text-field')
  String? get textField;

  /// Ordered list of font stacks to use for text rendering.
  ///
  /// Mapped to the `text-font` JSON key. The first available font is used.
  /// Supports comma-separated fallback names within each string entry.
  /// When null, falls back to MapLibre's default font.
  @JsonKey(name: 'text-font')
  List<String>? get textFont;

  /// The font size, which may be a constant scalar or a zoom-dependent stop
  /// function.
  ///
  /// Mapped to the `text-size` JSON key in pixels. Uses
  /// [MateoMapLibreStyleValueConverter] for serialization.
  @JsonKey(name: 'text-size')
  @MateoMapLibreStyleValueConverter()
  MateoMapLibreStyleValue? get textSize;

  /// The maximum line width for text wrapping, in ems.
  ///
  /// Mapped to the `text-max-width` JSON key. When null, MapLibre default
  /// (`10`) applies.
  @JsonKey(name: 'text-max-width')
  double? get textMaxWidth;

  /// The text anchor position relative to the label point.
  ///
  /// Mapped to the `text-anchor` JSON key. Values: `"center"`, `"top"`,
  /// `"bottom"`, `"left"`, `"right"`, `"top-left"`, `"top-right"`,
  /// `"bottom-left"`, `"bottom-right"`. Defaults to `"center"` when null.
  @JsonKey(name: 'text-anchor')
  String? get textAnchor;

  /// Letter spacing in ems (e.g. `0.15` adds 15% of one em between letters).
  ///
  /// Mapped to the `text-letter-spacing` JSON key. When null, MapLibre
  /// default (`0`) applies.
  @JsonKey(name: 'text-letter-spacing')
  double? get textLetterSpacing;

  /// Text transform applied to the label content.
  ///
  /// Mapped to the `text-transform` JSON key. Values: `"none"`,
  /// `"uppercase"`, `"lowercase"`. When null, `"none"` applies.
  @JsonKey(name: 'text-transform')
  String? get textTransform;

  /// Label placement mode relative to the geometry.
  ///
  /// Mapped to the `symbol-placement` JSON key. `"point"` places labels at
  /// fixed points; `"line"` places them along lines (useful for road names).
  /// When null, `"point"` applies.
  @JsonKey(name: 'symbol-placement')
  String? get symbolPlacement;

  /// Create a copy of MateoMapLibreStyleSymbolLayout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleSymbolLayoutCopyWith<MateoMapLibreStyleSymbolLayout>
  get copyWith =>
      _$MateoMapLibreStyleSymbolLayoutCopyWithImpl<
        MateoMapLibreStyleSymbolLayout
      >(this as MateoMapLibreStyleSymbolLayout, _$identity);

  /// Serializes this MateoMapLibreStyleSymbolLayout to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MateoMapLibreStyleSymbolLayout &&
            (identical(other.textField, textField) ||
                other.textField == textField) &&
            const DeepCollectionEquality().equals(other.textFont, textFont) &&
            (identical(other.textSize, textSize) ||
                other.textSize == textSize) &&
            (identical(other.textMaxWidth, textMaxWidth) ||
                other.textMaxWidth == textMaxWidth) &&
            (identical(other.textAnchor, textAnchor) ||
                other.textAnchor == textAnchor) &&
            (identical(other.textLetterSpacing, textLetterSpacing) ||
                other.textLetterSpacing == textLetterSpacing) &&
            (identical(other.textTransform, textTransform) ||
                other.textTransform == textTransform) &&
            (identical(other.symbolPlacement, symbolPlacement) ||
                other.symbolPlacement == symbolPlacement));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    textField,
    const DeepCollectionEquality().hash(textFont),
    textSize,
    textMaxWidth,
    textAnchor,
    textLetterSpacing,
    textTransform,
    symbolPlacement,
  );

  @override
  String toString() {
    return 'MateoMapLibreStyleSymbolLayout(textField: $textField, textFont: $textFont, textSize: $textSize, textMaxWidth: $textMaxWidth, textAnchor: $textAnchor, textLetterSpacing: $textLetterSpacing, textTransform: $textTransform, symbolPlacement: $symbolPlacement)';
  }
}

/// @nodoc
abstract mixin class $MateoMapLibreStyleSymbolLayoutCopyWith<$Res> {
  factory $MateoMapLibreStyleSymbolLayoutCopyWith(
    MateoMapLibreStyleSymbolLayout value,
    $Res Function(MateoMapLibreStyleSymbolLayout) _then,
  ) = _$MateoMapLibreStyleSymbolLayoutCopyWithImpl;
  @useResult
  $Res call({
    @JsonKey(name: 'text-field') String? textField,
    @JsonKey(name: 'text-font') List<String>? textFont,
    @JsonKey(name: 'text-size')
    @MateoMapLibreStyleValueConverter()
    MateoMapLibreStyleValue? textSize,
    @JsonKey(name: 'text-max-width') double? textMaxWidth,
    @JsonKey(name: 'text-anchor') String? textAnchor,
    @JsonKey(name: 'text-letter-spacing') double? textLetterSpacing,
    @JsonKey(name: 'text-transform') String? textTransform,
    @JsonKey(name: 'symbol-placement') String? symbolPlacement,
  });

  $MateoMapLibreStyleValueCopyWith<$Res>? get textSize;
}

/// @nodoc
class _$MateoMapLibreStyleSymbolLayoutCopyWithImpl<$Res>
    implements $MateoMapLibreStyleSymbolLayoutCopyWith<$Res> {
  _$MateoMapLibreStyleSymbolLayoutCopyWithImpl(this._self, this._then);

  final MateoMapLibreStyleSymbolLayout _self;
  final $Res Function(MateoMapLibreStyleSymbolLayout) _then;

  /// Create a copy of MateoMapLibreStyleSymbolLayout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? textField = freezed,
    Object? textFont = freezed,
    Object? textSize = freezed,
    Object? textMaxWidth = freezed,
    Object? textAnchor = freezed,
    Object? textLetterSpacing = freezed,
    Object? textTransform = freezed,
    Object? symbolPlacement = freezed,
  }) {
    return _then(
      _self.copyWith(
        textField: freezed == textField
            ? _self.textField
            : textField // ignore: cast_nullable_to_non_nullable
                  as String?,
        textFont: freezed == textFont
            ? _self.textFont
            : textFont // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        textSize: freezed == textSize
            ? _self.textSize
            : textSize // ignore: cast_nullable_to_non_nullable
                  as MateoMapLibreStyleValue?,
        textMaxWidth: freezed == textMaxWidth
            ? _self.textMaxWidth
            : textMaxWidth // ignore: cast_nullable_to_non_nullable
                  as double?,
        textAnchor: freezed == textAnchor
            ? _self.textAnchor
            : textAnchor // ignore: cast_nullable_to_non_nullable
                  as String?,
        textLetterSpacing: freezed == textLetterSpacing
            ? _self.textLetterSpacing
            : textLetterSpacing // ignore: cast_nullable_to_non_nullable
                  as double?,
        textTransform: freezed == textTransform
            ? _self.textTransform
            : textTransform // ignore: cast_nullable_to_non_nullable
                  as String?,
        symbolPlacement: freezed == symbolPlacement
            ? _self.symbolPlacement
            : symbolPlacement // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }

  /// Create a copy of MateoMapLibreStyleSymbolLayout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleValueCopyWith<$Res>? get textSize {
    if (_self.textSize == null) {
      return null;
    }

    return $MateoMapLibreStyleValueCopyWith<$Res>(_self.textSize!, (value) {
      return _then(_self.copyWith(textSize: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MateoMapLibreStyleSymbolLayout].
extension MateoMapLibreStyleSymbolLayoutPatterns
    on MateoMapLibreStyleSymbolLayout {
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
    TResult Function(_MateoMapLibreStyleSymbolLayout value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSymbolLayout() when $default != null:
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
    TResult Function(_MateoMapLibreStyleSymbolLayout value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSymbolLayout():
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
    TResult? Function(_MateoMapLibreStyleSymbolLayout value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSymbolLayout() when $default != null:
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
      @JsonKey(name: 'text-field') String? textField,
      @JsonKey(name: 'text-font') List<String>? textFont,
      @JsonKey(name: 'text-size')
      @MateoMapLibreStyleValueConverter()
      MateoMapLibreStyleValue? textSize,
      @JsonKey(name: 'text-max-width') double? textMaxWidth,
      @JsonKey(name: 'text-anchor') String? textAnchor,
      @JsonKey(name: 'text-letter-spacing') double? textLetterSpacing,
      @JsonKey(name: 'text-transform') String? textTransform,
      @JsonKey(name: 'symbol-placement') String? symbolPlacement,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSymbolLayout() when $default != null:
        return $default(
          _that.textField,
          _that.textFont,
          _that.textSize,
          _that.textMaxWidth,
          _that.textAnchor,
          _that.textLetterSpacing,
          _that.textTransform,
          _that.symbolPlacement,
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
      @JsonKey(name: 'text-field') String? textField,
      @JsonKey(name: 'text-font') List<String>? textFont,
      @JsonKey(name: 'text-size')
      @MateoMapLibreStyleValueConverter()
      MateoMapLibreStyleValue? textSize,
      @JsonKey(name: 'text-max-width') double? textMaxWidth,
      @JsonKey(name: 'text-anchor') String? textAnchor,
      @JsonKey(name: 'text-letter-spacing') double? textLetterSpacing,
      @JsonKey(name: 'text-transform') String? textTransform,
      @JsonKey(name: 'symbol-placement') String? symbolPlacement,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSymbolLayout():
        return $default(
          _that.textField,
          _that.textFont,
          _that.textSize,
          _that.textMaxWidth,
          _that.textAnchor,
          _that.textLetterSpacing,
          _that.textTransform,
          _that.symbolPlacement,
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
      @JsonKey(name: 'text-field') String? textField,
      @JsonKey(name: 'text-font') List<String>? textFont,
      @JsonKey(name: 'text-size')
      @MateoMapLibreStyleValueConverter()
      MateoMapLibreStyleValue? textSize,
      @JsonKey(name: 'text-max-width') double? textMaxWidth,
      @JsonKey(name: 'text-anchor') String? textAnchor,
      @JsonKey(name: 'text-letter-spacing') double? textLetterSpacing,
      @JsonKey(name: 'text-transform') String? textTransform,
      @JsonKey(name: 'symbol-placement') String? symbolPlacement,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MateoMapLibreStyleSymbolLayout() when $default != null:
        return $default(
          _that.textField,
          _that.textFont,
          _that.textSize,
          _that.textMaxWidth,
          _that.textAnchor,
          _that.textLetterSpacing,
          _that.textTransform,
          _that.symbolPlacement,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable(createFactory: false)
class _MateoMapLibreStyleSymbolLayout
    implements MateoMapLibreStyleSymbolLayout {
  const _MateoMapLibreStyleSymbolLayout({
    @JsonKey(name: 'text-field') this.textField,
    @JsonKey(name: 'text-font') final List<String>? textFont,
    @JsonKey(name: 'text-size')
    @MateoMapLibreStyleValueConverter()
    this.textSize,
    @JsonKey(name: 'text-max-width') this.textMaxWidth,
    @JsonKey(name: 'text-anchor') this.textAnchor,
    @JsonKey(name: 'text-letter-spacing') this.textLetterSpacing,
    @JsonKey(name: 'text-transform') this.textTransform,
    @JsonKey(name: 'symbol-placement') this.symbolPlacement,
  }) : _textFont = textFont;

  /// The text content expression (e.g. `"{name}"` to use a feature property).
  ///
  /// Mapped to the `text-field` JSON key. Accepts a field reference (in
  /// curly braces) or a string literal. When null, no text is rendered.
  @override
  @JsonKey(name: 'text-field')
  final String? textField;

  /// Ordered list of font stacks to use for text rendering.
  ///
  /// Mapped to the `text-font` JSON key. The first available font is used.
  /// Supports comma-separated fallback names within each string entry.
  /// When null, falls back to MapLibre's default font.
  final List<String>? _textFont;

  /// Ordered list of font stacks to use for text rendering.
  ///
  /// Mapped to the `text-font` JSON key. The first available font is used.
  /// Supports comma-separated fallback names within each string entry.
  /// When null, falls back to MapLibre's default font.
  @override
  @JsonKey(name: 'text-font')
  List<String>? get textFont {
    final value = _textFont;
    if (value == null) return null;
    if (_textFont is EqualUnmodifiableListView) return _textFont;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// The font size, which may be a constant scalar or a zoom-dependent stop
  /// function.
  ///
  /// Mapped to the `text-size` JSON key in pixels. Uses
  /// [MateoMapLibreStyleValueConverter] for serialization.
  @override
  @JsonKey(name: 'text-size')
  @MateoMapLibreStyleValueConverter()
  final MateoMapLibreStyleValue? textSize;

  /// The maximum line width for text wrapping, in ems.
  ///
  /// Mapped to the `text-max-width` JSON key. When null, MapLibre default
  /// (`10`) applies.
  @override
  @JsonKey(name: 'text-max-width')
  final double? textMaxWidth;

  /// The text anchor position relative to the label point.
  ///
  /// Mapped to the `text-anchor` JSON key. Values: `"center"`, `"top"`,
  /// `"bottom"`, `"left"`, `"right"`, `"top-left"`, `"top-right"`,
  /// `"bottom-left"`, `"bottom-right"`. Defaults to `"center"` when null.
  @override
  @JsonKey(name: 'text-anchor')
  final String? textAnchor;

  /// Letter spacing in ems (e.g. `0.15` adds 15% of one em between letters).
  ///
  /// Mapped to the `text-letter-spacing` JSON key. When null, MapLibre
  /// default (`0`) applies.
  @override
  @JsonKey(name: 'text-letter-spacing')
  final double? textLetterSpacing;

  /// Text transform applied to the label content.
  ///
  /// Mapped to the `text-transform` JSON key. Values: `"none"`,
  /// `"uppercase"`, `"lowercase"`. When null, `"none"` applies.
  @override
  @JsonKey(name: 'text-transform')
  final String? textTransform;

  /// Label placement mode relative to the geometry.
  ///
  /// Mapped to the `symbol-placement` JSON key. `"point"` places labels at
  /// fixed points; `"line"` places them along lines (useful for road names).
  /// When null, `"point"` applies.
  @override
  @JsonKey(name: 'symbol-placement')
  final String? symbolPlacement;

  /// Create a copy of MateoMapLibreStyleSymbolLayout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MateoMapLibreStyleSymbolLayoutCopyWith<_MateoMapLibreStyleSymbolLayout>
  get copyWith =>
      __$MateoMapLibreStyleSymbolLayoutCopyWithImpl<
        _MateoMapLibreStyleSymbolLayout
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MateoMapLibreStyleSymbolLayoutToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MateoMapLibreStyleSymbolLayout &&
            (identical(other.textField, textField) ||
                other.textField == textField) &&
            const DeepCollectionEquality().equals(other._textFont, _textFont) &&
            (identical(other.textSize, textSize) ||
                other.textSize == textSize) &&
            (identical(other.textMaxWidth, textMaxWidth) ||
                other.textMaxWidth == textMaxWidth) &&
            (identical(other.textAnchor, textAnchor) ||
                other.textAnchor == textAnchor) &&
            (identical(other.textLetterSpacing, textLetterSpacing) ||
                other.textLetterSpacing == textLetterSpacing) &&
            (identical(other.textTransform, textTransform) ||
                other.textTransform == textTransform) &&
            (identical(other.symbolPlacement, symbolPlacement) ||
                other.symbolPlacement == symbolPlacement));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    textField,
    const DeepCollectionEquality().hash(_textFont),
    textSize,
    textMaxWidth,
    textAnchor,
    textLetterSpacing,
    textTransform,
    symbolPlacement,
  );

  @override
  String toString() {
    return 'MateoMapLibreStyleSymbolLayout(textField: $textField, textFont: $textFont, textSize: $textSize, textMaxWidth: $textMaxWidth, textAnchor: $textAnchor, textLetterSpacing: $textLetterSpacing, textTransform: $textTransform, symbolPlacement: $symbolPlacement)';
  }
}

/// @nodoc
abstract mixin class _$MateoMapLibreStyleSymbolLayoutCopyWith<$Res>
    implements $MateoMapLibreStyleSymbolLayoutCopyWith<$Res> {
  factory _$MateoMapLibreStyleSymbolLayoutCopyWith(
    _MateoMapLibreStyleSymbolLayout value,
    $Res Function(_MateoMapLibreStyleSymbolLayout) _then,
  ) = __$MateoMapLibreStyleSymbolLayoutCopyWithImpl;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'text-field') String? textField,
    @JsonKey(name: 'text-font') List<String>? textFont,
    @JsonKey(name: 'text-size')
    @MateoMapLibreStyleValueConverter()
    MateoMapLibreStyleValue? textSize,
    @JsonKey(name: 'text-max-width') double? textMaxWidth,
    @JsonKey(name: 'text-anchor') String? textAnchor,
    @JsonKey(name: 'text-letter-spacing') double? textLetterSpacing,
    @JsonKey(name: 'text-transform') String? textTransform,
    @JsonKey(name: 'symbol-placement') String? symbolPlacement,
  });

  @override
  $MateoMapLibreStyleValueCopyWith<$Res>? get textSize;
}

/// @nodoc
class __$MateoMapLibreStyleSymbolLayoutCopyWithImpl<$Res>
    implements _$MateoMapLibreStyleSymbolLayoutCopyWith<$Res> {
  __$MateoMapLibreStyleSymbolLayoutCopyWithImpl(this._self, this._then);

  final _MateoMapLibreStyleSymbolLayout _self;
  final $Res Function(_MateoMapLibreStyleSymbolLayout) _then;

  /// Create a copy of MateoMapLibreStyleSymbolLayout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? textField = freezed,
    Object? textFont = freezed,
    Object? textSize = freezed,
    Object? textMaxWidth = freezed,
    Object? textAnchor = freezed,
    Object? textLetterSpacing = freezed,
    Object? textTransform = freezed,
    Object? symbolPlacement = freezed,
  }) {
    return _then(
      _MateoMapLibreStyleSymbolLayout(
        textField: freezed == textField
            ? _self.textField
            : textField // ignore: cast_nullable_to_non_nullable
                  as String?,
        textFont: freezed == textFont
            ? _self._textFont
            : textFont // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        textSize: freezed == textSize
            ? _self.textSize
            : textSize // ignore: cast_nullable_to_non_nullable
                  as MateoMapLibreStyleValue?,
        textMaxWidth: freezed == textMaxWidth
            ? _self.textMaxWidth
            : textMaxWidth // ignore: cast_nullable_to_non_nullable
                  as double?,
        textAnchor: freezed == textAnchor
            ? _self.textAnchor
            : textAnchor // ignore: cast_nullable_to_non_nullable
                  as String?,
        textLetterSpacing: freezed == textLetterSpacing
            ? _self.textLetterSpacing
            : textLetterSpacing // ignore: cast_nullable_to_non_nullable
                  as double?,
        textTransform: freezed == textTransform
            ? _self.textTransform
            : textTransform // ignore: cast_nullable_to_non_nullable
                  as String?,
        symbolPlacement: freezed == symbolPlacement
            ? _self.symbolPlacement
            : symbolPlacement // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }

  /// Create a copy of MateoMapLibreStyleSymbolLayout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MateoMapLibreStyleValueCopyWith<$Res>? get textSize {
    if (_self.textSize == null) {
      return null;
    }

    return $MateoMapLibreStyleValueCopyWith<$Res>(_self.textSize!, (value) {
      return _then(_self.copyWith(textSize: value));
    });
  }
}
