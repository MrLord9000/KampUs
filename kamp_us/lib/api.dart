import 'dart:io';

import 'package:kamp_us/dataBase.dart';
import 'package:kamp_us/models.dart';
import 'package:kamp_us/view_models/location.dart';
import 'package:mysql1/mysql1.dart';

class API
{
  static const ER_DUP_ENTRY = 1062;
  static const ER_NO_SUCH_TABLE = 1146;
  static const ER_BAD_FIELD_ERROR = 1054;

  static String _unknownErrorLog( String errorLog ) {
    return "Wystąpił nieznany błąd: " + errorLog + ", proszę skontaktować się z administratorem";
  }

  static logIn( String email, String password, Function ifSuccess, Function ifFailure ) async {
    try
    {
      Results result = await DataBase().query(
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
      await DataBase().query(
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

  static Future<Location> load(Location loc, Function ifSuccess, Function ifFailure) async {        
    loc.isValid = false;
    try
    {
      Results location = await DataBase().query(
        "SELECT * FROM locations WHERE id = ?",
        [loc.id]
      );

      if ( location.length < 1 ) {
        // No email in database
        ifFailure("Nie odnaleziono podanej lokacji");
      }
      else
      {
        int i = 0;
        print(i++);
        Results thumbs = await DataBase().query(
          "SELECT * FROM thumbs WHERE loc_id = ?",
          [loc.id]
        );
        int thumbsNumber = thumbs.length;
        print(i++);

        Results comments = await DataBase().query(
          "SELECT * FROM comments WHERE loc_id = ?",
          [loc.id]
        );
        
        List<CommentModel> commentsList= new List<CommentModel>();
        for (var row in comments) {
          commentsList.add( new CommentModel( row[0], row[1], row[2], row[3].toString() ) );
        }
        print(i++);

        Results tags = await DataBase().query(
          "SELECT tag FROM tags WHERE id IN (SELECT tag_id FROM loc_tag WHERE loc_id = ?) ",
          [loc.id]
        );

        List<String> tagsList= new List<String>();
        for (var row in tags) {
          tagsList.add(row[0]);
        }
        print(i++);

        Results creator = await DataBase().query(
          "SELECT nickname, email FROM accounts WHERE id = ?",
          [location.first[1]]
        );
        print(i++);
        
        ifSuccess();
        loc = new Location(
          id: location.first[0],
          accountNickname: creator.first[0] ?? creator.first[1],
          name: location.first[2].toString(),
          description: location.first[3].toString(),
          latitude: location.first[4],
          longitude: location.first[5],
          isVerified: location.first[6] == 0,
          category: CategoryFromString(location.first[7]),
          thumbs: thumbsNumber,
          tags: tagsList,
          comments: commentsList,
        );
        loc.isValid = true;
        
        return loc;       
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
    return null;
  }

  static update(Location loc, Function ifSuccess, Function ifFailure) async {
    try
    {
      await DataBase().query(
        "UPDATE `locations` SET `name`=?,`description`=?,`latitude`=?,`longitude`=?,`category`=? WHERE `id`=?", [
          // SET
          loc.name,
          loc.description,
          loc.latitude,
          loc.longitude,
          loc.category.toString().split('.').last,
          // WHERE
          loc.id
        ]
      );
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

  static insert(Location loc, Function ifSuccess, Function ifFailure) async {
    try
    {
      await DataBase().query(
        "INSERT INTO `locations`(`user_id`, `name`, `description`, `latitude`, `longitude`,`category`) VALUES (?,?,?,?,?,?)", [
          2,//TODO user id
          loc.name,
          loc.description,
          loc.latitude,
          loc.longitude,
          loc.category.toString().split('.').last,
        ]
      );
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

  static delete(Location loc, Function ifSuccess, Function ifFailure) async {
    try
    {
      Future q1 = DataBase().query(
        "DELETE FROM locations WHERE id = ?",
        [loc.id]
      ); 
      Future q2 = DataBase().query(
        "DELETE FROM loc_tag WHERE loc_id = ?",
        [loc.id]
      );
      Future q3 = DataBase().query(
        "DELETE FROM comments WHERE loc_id = ?",
        [loc.id]
      );
      await q1;
      await q2;
      await q3;
      ifSuccess();
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
