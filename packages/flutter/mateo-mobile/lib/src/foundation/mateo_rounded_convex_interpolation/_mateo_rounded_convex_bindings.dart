part of 'mateo_rounded_convex_evaluator.dart';

@ffi.Native<ffi.Pointer<ffi.Void> Function(ffi.Size, ffi.Size)>(symbol: 'mateo_allocate')
external ffi.Pointer<ffi.Void> _mateoAllocate(int count, int size);

@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(symbol: 'mateo_release')
external void _mateoRelease(ffi.Pointer<ffi.Void> pointer);

@ffi.Native<
  ffi.Pointer<ffi.Void> Function(
    ffi.Pointer<ffi.Double>,
    ffi.Size,
    ffi.Pointer<ffi.Double>,
    ffi.Size,
    ffi.Pointer<ffi.Double>,
    ffi.Int32,
    ffi.Size,
    ffi.Pointer<ffi.Double>,
    ffi.Int32,
    ffi.Size,
    ffi.Int32,
  )
>(symbol: 'mateo_create_checked')
external ffi.Pointer<ffi.Void> _mateoCreateChecked(
  ffi.Pointer<ffi.Double> begin,
  int beginLength,
  ffi.Pointer<ffi.Double> end,
  int endLength,
  ffi.Pointer<ffi.Double> beginPoints,
  int beginCount,
  int beginCapacity,
  ffi.Pointer<ffi.Double> endPoints,
  int endCount,
  int endCapacity,
  int rounded,
);

@ffi.Native<
  ffi.Pointer<ffi.Void> Function(
    ffi.Double,
    ffi.Double,
    ffi.Double,
    ffi.Double,
    ffi.Pointer<ffi.Double>,
    ffi.Int32,
    ffi.Size,
    ffi.Pointer<ffi.Double>,
    ffi.Int32,
    ffi.Size,
  )
>(symbol: 'mateo_create_physical_checked')
external ffi.Pointer<ffi.Void> _mateoCreatePhysicalChecked(
  double beginWidth,
  double beginHeight,
  double endWidth,
  double endHeight,
  ffi.Pointer<ffi.Double> beginPoints,
  int beginCount,
  int beginCapacity,
  ffi.Pointer<ffi.Double> endPoints,
  int endCount,
  int endCapacity,
);

@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(symbol: 'mateo_destroy')
external void _mateoDestroy(ffi.Pointer<ffi.Void> handle);

@ffi.Native<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>(symbol: 'mateo_reverse')
external ffi.Pointer<ffi.Void> _mateoReverse(ffi.Pointer<ffi.Void> handle);

@ffi.Native<ffi.Pointer<ffi.Double> Function(ffi.Pointer<ffi.Void>, ffi.Double, ffi.Pointer<ffi.Int32>)>(
  symbol: 'mateo_frame',
)
external ffi.Pointer<ffi.Double> _mateoFrame(
  ffi.Pointer<ffi.Void> handle,
  double progress,
  ffi.Pointer<ffi.Int32> count,
);

@ffi.Native<ffi.Size Function(ffi.Pointer<ffi.Void>)>(symbol: 'mateo_retained_bytes', isLeaf: true)
external int _mateoRetainedBytes(ffi.Pointer<ffi.Void> handle);

@ffi.Native<ffi.Pointer<ffi.Uint8> Function()>(symbol: 'mateo_error', isLeaf: true)
external ffi.Pointer<ffi.Uint8> _mateoError();

@ffi.Native<ffi.Pointer<ffi.Void> Function()>(symbol: 'mateo_path_create')
external ffi.Pointer<ffi.Void> _mateoPathCreate();

@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Void>)>(symbol: 'mateo_path_destroy')
external void _mateoPathDestroy(ffi.Pointer<ffi.Void> handle);

@ffi.Native<ffi.Size Function(ffi.Pointer<ffi.Void>)>(symbol: 'mateo_path_retained_bytes', isLeaf: true)
external int _mateoPathRetainedBytes(ffi.Pointer<ffi.Void> handle);

@ffi.Native<
  ffi.Pointer<ffi.Float> Function(
    ffi.Pointer<ffi.Void>,
    ffi.Pointer<ffi.Double>,
    ffi.Int32,
    ffi.Double,
    ffi.Double,
    ffi.Double,
    ffi.Double,
    ffi.Double,
    ffi.Pointer<ffi.Int32>,
  )
>(symbol: 'mateo_path_prepare')
external ffi.Pointer<ffi.Float> _mateoPathPrepare(
  ffi.Pointer<ffi.Void> handle,
  ffi.Pointer<ffi.Double> points,
  int count,
  double left,
  double top,
  double width,
  double height,
  double tolerance,
  ffi.Pointer<ffi.Int32> outputCount,
);

final _mateoBufferFinalizer = ffi.NativeFinalizer(ffi.Native.addressOf(_mateoRelease));
