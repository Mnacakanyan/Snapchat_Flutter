import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat_ui/DataBase/db.dart';
part 'countrycodeinmobile_event.dart';
part 'countrycodeinmobile_state.dart';

class CountrycodeinmobileBloc
    extends Bloc<CountrycodeinmobileEvent, CountrycodeinmobileState> {
  CountrycodeinmobileBloc() : super(CountrycodeinmobileInitial()) {
    on<TextChanged>((event, emit) async {
      emit(await DBProvider.db.filterCountry(event.text) == [] ||
              await DBProvider.db.filterCountry(event.text) == null
          ? CountryDetected()
          : CountryNotDetected());
    });
  }

  // @override
  // Stream<CountrycodeinmobileState> mapEventToState(
  //   CountrycodeinmobileEvent event,
  // ) async* {
  //   if(event is TextChanged){

  //     yield (await DBProvider.db.filterCountry(event.text)==[] || await DBProvider.db.filterCountry(event.text)==null)?CountryDetected():CountryNotDetected();
  //   }
  // }

}
