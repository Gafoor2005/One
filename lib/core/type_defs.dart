import 'package:fpdart/fpdart.dart';
import 'package:one/core/failuer.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
