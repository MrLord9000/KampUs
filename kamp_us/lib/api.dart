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

  // By id or email
  static Future<AccountModel> loadAccount( AccountModel acc, Function ifSuccess, Function ifFailure ) async {
    try
    {
      Results result = await DataBase().query(
        "SELECT * FROM accounts WHERE id = ? OR email = ?",
        [acc.id,acc.email]
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
        return new AccountModel(
          id: result.first[0],
          email: result.first[1].toString(),
          passwd: result.first[2].toString(),
          nickname: result.first[3]?.toString() ?? result.first[1].toString(),
        );
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

  static logIn( AccountModel acc, Function ifSuccess, Function ifFailure ) async {        
    var fromDB = await loadAccount(acc, ifSuccess, ifFailure);
    // Eamil found in database
    //TODO hashing password!!!
    if ( fromDB.passwd == acc.passwd ) {
      // Good password
      print("Login ok");
      ifSuccess();
    }
    else {
      // Wrong password
      ifFailure("Nieprawidłowe hasło");
    }
  }

  static createAccount( AccountModel acc, Function ifSuccess, Function ifFailure ) async {
    try
    {
      await DataBase().query(
        "INSERT INTO `accounts` (`email`,`password`) VALUES (?,?)",
        [acc.email,acc.passwd]
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

  // by id
  static Future<Location> loadLocation(Location loc, Function ifSuccess, Function ifFailure) async {        
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
        AccountModel acc;
        int thumbsNumber;        
        List<CommentModel> commentsList= new List<CommentModel>();
        List<String> tagsList= new List<String>();

        // TODO Replace queries by methods, where then will be done
        Future loadAcc = loadAccount(new AccountModel(id: location.first[1]), ifSuccess, ifFailure)
          .then((result) => {acc = result});
        Future loadThumbs = DataBase().query( "SELECT * FROM thumbs WHERE loc_id = ?", [loc.id])
          .then((result) => {thumbsNumber = result.length});        
        Future loadcomments = DataBase().query( "SELECT * FROM comments WHERE loc_id = ?", [loc.id])
          .then((result) => {
            for (var row in result) {
              commentsList.add( 
                new CommentModel( 
                  id: row[0],
                  userId: row[1],
                  locId: row[2],
                  text: row[3].toString()
                )
              )
            }
          });
        Future loadTags = DataBase().query("SELECT tag FROM tags WHERE id IN (SELECT tag_id FROM loc_tag WHERE loc_id = ?) ", [loc.id])
          .then((result) => {
            for (var row in result) {
              tagsList.add(row[0])
            }
          });
        
        await loadAcc;
        await loadThumbs;
        await loadcomments;
        await loadTags;

        ifSuccess();
        loc = new Location(
          id: location.first[0],
          creator: acc,
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

  static updateLocation(Location loc, Function ifSuccess, Function ifFailure) async {
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

  static createLocation(Location loc, Function ifSuccess, Function ifFailure) async {
    try
    {
      await DataBase().query(
        "INSERT INTO `locations`(`user_id`, `name`, `description`, `latitude`, `longitude`,`category`) VALUES (?,?,?,?,?,?)", [
          loc.creator.id,
          loc.name,
          loc.description,
          loc.latitude,
          loc.longitude,
          loc.category.toString().split('.').last,
        ]
      );
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

  static deleteLocation(Location loc, Function ifSuccess, Function ifFailure) async {
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
