import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pizza_repository/pizza_repository.dart';

part 'get_pizza_event.dart';
part 'get_pizza_state.dart';

class GetPizzaBloc extends Bloc<GetPizzaEvent, GetPizzaState> {
  final PizzaRepo _pizzaRepo;

  GetPizzaBloc(this._pizzaRepo) : super(GetPizzaInitial()) {
   on<GetPizza>((event, emit) async {
  print("GetPizza event received!"); // Kiểm tra sự kiện được nhận

  emit(GetPizzaLoading());
  try {
    List<Pizza> pizzas = await _pizzaRepo.getPizzas();
    print("Fetched pizzas: ${pizzas.length}"); // Kiểm tra dữ liệu trả về
    emit(GetPizzaSuccess(pizzas));
  } catch (e) {
    print("Error fetching pizzas: $e"); // In lỗi nếu có
    emit(GetPizzaFailure());
  }
});

  }
}
