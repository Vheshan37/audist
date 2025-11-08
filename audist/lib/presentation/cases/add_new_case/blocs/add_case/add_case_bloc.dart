import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_case_event.dart';
part 'add_case_state.dart';

class AddCaseBloc extends Bloc<AddCaseEvent, AddCaseState> {
  AddCaseBloc() : super(AddCaseInitial()) {
    on<RequestAddCaseEvent>((event, emit) {

    });
  }
}
