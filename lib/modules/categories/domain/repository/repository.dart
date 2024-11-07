abstract class Repository<T, P> {
  Future<P> execute(T type);
}
