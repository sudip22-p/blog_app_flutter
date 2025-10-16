// Base abstract use case class that defines the contract for all use cases.
import 'dart:async';

abstract class UseCase<ReturnType, Params> {
  FutureOr<ReturnType> execute(Params params);
}
