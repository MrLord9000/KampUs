import 'dart:io';

import 'package:kamp_us/dataBase.dart';
import 'package:mysql1/mysql1.dart';

class API
{
  static const ER_DUP_ENTRY = 1062;

  static String _unknownErrorLog( String errorLog ) {
    return "Wystąpił nieznany błąd: " + errorLog + ", proszę skontaktować się z administratorem";
  }

  static logIn( String email, String password, Function ifSuccess, Function ifFailure ) async {
    try
    {
      Results result = await DataBase().querry(
        "SELECT password FROM accounts WHERE email = ?",
        [email]
      );
            
      if ( result.length < 1 ) {
        // No email in database
        ifFailure("Nieprawidłowy adres email");
      }
      else if ( result.length > 1 ) {
        // Duplicatet email in database (SOMEHOW)
        ifFailure("BŁĄD BAZY DANYCH: zduplikowany emai! - proszę skontaktować się z administratorem");
      }
      else {
        // Eamil found in database
        if ( result.first[0].toString() == password ) {
          // Good password
          print("Login ok");
          ifSuccess();
        }
        else {
          // Wrong password
          ifFailure("Nieprawidłowe hasło");
        }
      }
    }    
    on SocketException catch(exc) {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      print(exc.runtimeType);
    }
  }

  static createAccount( String email, String password, Function ifSuccess, Function ifFailure ) async {
    try
    {
      await DataBase().querry(
        "INSERT INTO `accounts` (`email`,`password`) VALUES (?,?)",
        [email,password]
      );
      ifSuccess('Dziękujemy za rejestrację, link do aktywacji został wysłany na podany adres email');
    }
    on MySqlException catch(exc)
    {
      switch (exc.errorNumber) {
        case ER_DUP_ENTRY: 
          ifFailure("Podany adres email jest już używany");
          break;
        default:
          ifFailure(_unknownErrorLog(exc.toString()));
          print(exc.runtimeType);
          break;
      }
    }
    on SocketException catch(exc) {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      print(exc.runtimeType);
    }

  }
}
