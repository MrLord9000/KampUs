import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mysql1/mysql1.dart';
import 'package:password_hash/salt.dart';
import 'package:password_hash/pbkdf2.dart';

import 'package:kamp_us/dataBase.dart';
import 'package:kamp_us/models.dart';
import 'package:kamp_us/view_models/location.dart';

class API
{
  static const int THUMBS_TO_VERIFY = 10;

  static const ER_BAD_FIELD_ERROR = 1054;
  static const ER_DUP_ENTRY = 1062;
  static const ER_NO_SUCH_TABLE = 1146;

  static final _storage = new FlutterSecureStorage();

  static PBKDF2 _passwdGenerator = new PBKDF2();
  static AccountModel _accountNoPass;
  
  static String _unknownErrorLog( String errorLog ) {
    return "Wystąpił nieznany błąd: " + errorLog + ", proszę skontaktować się z administratorem";
  }

  static _exceptionDebug(exc){
    print("EXCEPTION");
    print("type: " + exc.runtimeType.toString());
    print("messange: " + exc.message);
  }

  static get currentUserAsync async {
    var storedData = await _storage.readAll();

    if( storedData["remember"] == "true" ) {
        return new AccountModel(
        id: int.parse( storedData["id"] ),
        email: storedData["email"],
        passwd: storedData["passwd"],
        salt: storedData["salt"],
        nickname: storedData["nickName"]
      );
    }
    else {
      return null;
    }
  }

  static get currentUserNoPass => _accountNoPass;

  static saveUser(AccountModel acc) async {
    var op1 = _storage.write(key: "remember", value: "true");
    var op2 = _storage.write(key: "id", value: acc.id.toString() );
    var op3 = _storage.write(key: "email", value: acc.email );
    var op4 = _storage.write(key: "passwd", value: acc.passwd );
    var op5 = _storage.write(key: "salt", value: acc.salt );
    var op6 = _storage.write(key: "nickName", value: acc.nickname);
    _accountNoPass = new AccountModel( id: acc.id, email: acc.email, nickname: acc.nickname);
    await op1; await op2; await op3; await op4; await op5; await op6;
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
          salt: result.first[3].toString(),
          nickname: result.first[4]?.toString() ?? result.first[1].toString(),
        );
      }
    }    
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
    return null;
  }

  static logIn( AccountModel acc, Function ifSuccess, Function ifFailure ) async {        
    var fromDB = await loadAccount(acc, ifSuccess, ifFailure);
    // Eamil found in database
    String encrypted = _passwdGenerator.generateBase64Key(acc.passwd, fromDB.salt, 10, 256);

    if ( fromDB.passwd == encrypted ) {
      // Good password
      print("Login ok");
      fromDB.passwd = acc.passwd;
      await saveUser(fromDB);
      ifSuccess();
    }
    else {
      // Wrong password
      ifFailure("Nieprawidłowe hasło");
    }
  }

  static logInFromSafeStorage( Function ifSuccess, Function ifFailure ) async {
    
    print("trying to log");
    
    var acc = await currentUserAsync;

    
    print("storage ok");
    if( acc != null ) {
      logIn(acc, ifSuccess, ifFailure);
      print("data in storage");
    }
    else {
      ifFailure("No stored user");
      print("storage empty");
    }
  }

  static logOut() async {    
    var op1 = _storage.write(key: "remember", value: "false");
    var op2 = _storage.delete(key: "id");
    var op3 = _storage.delete(key: "email");
    var op4 = _storage.delete(key: "passwd");
    var op5 = _storage.delete(key: "salt");
    var op6 = _storage.delete(key: "nickName");
    _accountNoPass = null;
    await op1; await op2; await op3; await op4; await op5; await op6;
  }

  static createAccount( AccountModel acc, Function ifSuccess, Function ifFailure ) async {
    try
    {
      String salt = Salt.generateAsBase64String(64);
      String passwd = _passwdGenerator.generateBase64Key(acc.passwd, salt, 10, 256);
      await DataBase().query(
        "INSERT INTO `accounts` (`email`,`password`,`salt`) VALUES (?,?,?)",
        [acc.email,passwd,salt]
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
          print("EXCEPTION");
          print("type: " + exc.runtimeType.toString());
          print("messange: " + exc.message);
          break;
      }
    }
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
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
        List<CommentModel> commentsList;
        List<String> tagsList= new List<String>();

        Future loadAcc = loadAccount(new AccountModel(id: location.first[1]), ifSuccess, ifFailure)
          .then((result) => {acc = result});
        Future loadThumbs = loadLocationsThumbs(loc, ifSuccess, ifFailure)
          .then((result) => {thumbsNumber = result.length});        
        Future loadcomments = loadLocationsComments(loc, ifSuccess, ifFailure) 
          .then((result) => { commentsList = result });
        Future loadTags = loadLocationsTags(loc, ifSuccess, ifFailure)
          .then((result) => {
            for (var tag in result) {
              tagsList.add(tag.tag)
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
          category: categoryFromString(location.first[7]),
          thumbs: thumbsNumber,
          tags: tagsList,
          comments: commentsList,
        );
        loc.isValid = true;
        
        return loc;       
      }
    }
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
    return null;
  }

  static Future<List<Location>> loadLocationsInRange(double lngMIn, double lngMax, double latMIn, double latMax, Function ifSuccess, Function ifFailure) async {
    try
    {
      Results result = await DataBase().query(
        "SELECT id FROM locations WHERE (longitude BETWEEN ? AND ?) AND (latitude BETWEEN ? AND ?)",
        [lngMIn,lngMax,latMIn,latMax]
      );
      var locs = new List<Location>();
      for (var row in result) {
        locs.add( await loadLocation( new Location( id: row[0] ), ifSuccess, ifFailure) );
      }
      return locs;
    }
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
    return null;
  }

  static Future<List<ThumbModel>> loadLocationsThumbs(Location loc, Function ifSuccess, Function ifFailure) async {
    try
    {
      var list = new List<ThumbModel>();
      Results result = await DataBase().query( "SELECT * FROM thumbs WHERE loc_id = ?", [loc.id]);
      for (var row in result) {
        list.add( new ThumbModel(
          id: row[0],
          userId: row[1],
          locId: row[2]
        ));
      } 
      return list;
    }    
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
    return null;
  }
  
  static Future<List<CommentModel>> loadLocationsComments(Location loc, Function ifSuccess, Function ifFailure) async {
    try
    {
      var list = new List<CommentModel>();
      Results result = await DataBase().query( "SELECT * FROM comments WHERE loc_id = ?", [loc.id]);
      for (var row in result) {
        list.add( new CommentModel(
          id: row[0],
          userId: row[1],
          locId: row[2],
          text: row[3].toString()
        ));
      } 
      return list;
    }    
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
    return null;
  }

  static Future<List<TagModel>> loadLocationsTags(Location loc, Function ifSuccess, Function ifFailure) async {
    try
    {
      var list = new List<TagModel>();
      Results result = await DataBase().query("SELECT * FROM tags WHERE id IN (SELECT tag_id FROM loc_tag WHERE loc_id = ?) ", [loc.id]);
      for (var row in result) {
        list.add( new TagModel(
          id: row[0],
          tag: row[1].toString(),
        ));
      } 
      return list;
    }    
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
    return null;
  }
  
  static Future<List<TagModel>> loadAllTags( Function ifSuccess, Function ifFailure) async {
    try
    {
      var list = new List<TagModel>();
      Results result = await DataBase().query("SELECT * FROM tags",[]);
      for (var row in result) {
        list.add( new TagModel(
          id: row[0],
          tag: row[1].toString(),
        ));
      }

      return list;
    }    
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
    return null;
  }
  
  //TODO incomplete
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
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
  }

  static createLocation(Location loc, Function ifSuccess, Function ifFailure) async {
    try
    {
      var futureTagModels = new List<Future<TagModel>>();

      for (var tag in loc.tags) {
        await createTag(tag, (){}, ifFailure);
        futureTagModels.add( loadTag(tag, (){}, ifFailure) );
        print("xD");
      }      
      int userID = (await API.currentUserAsync).id;
      loc.id = (await DataBase().query("SELECT MAX(id) FROM locations",[])).first[0]+1;
      await DataBase().query(
        "INSERT INTO `locations`(`id`,`user_id`, `name`, `description`, `latitude`, `longitude`,`category`) VALUES (?,?,?,?,?,?,?)", [
          loc.id,
          userID,
          loc.name,
          loc.description,
          loc.latitude,
          loc.longitude,
          loc.category.toString().split('.').last,
        ]
      );

      for (var future in futureTagModels) {
        DataBase().query("INSERT INTO loc_tag (loc_id,tag_id) VALUES (?,?)",[loc.id,(await future).id]);
      }

      ifSuccess();
    }
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
  }

  // by id
  static deleteLocation(Location loc, Function ifSuccess, Function ifFailure) async {
    try
    {
      Future q1 = DataBase().query( "DELETE FROM locations WHERE id = ?", [loc.id] ); 
      Future q2 = DataBase().query( "DELETE FROM loc_tag WHERE loc_id = ?", [loc.id] );
      Future q3 = DataBase().query( "DELETE FROM comments WHERE loc_id = ?", [loc.id] );
      Future q4 = DataBase().query( "DELETE FROM thumbs WHERE loc_id = ?", [loc.id] );
      await q1; await q2; await q3; await q4;
      ifSuccess();
    }
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
  }

  static createComment(CommentModel com, Function ifSuccess, Function ifFailure ) async {
    try
    {
      await DataBase().query(
        "INSERT INTO `comments` (`user_id`,`loc_id`,`text`) VALUES (?,?,?)",
        [com.userId,com.locId,com.text]
      );
      ifSuccess();
    }
    on MySqlException catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
  }

  static createThumb(ThumbModel thumb, Function ifSuccess, Function ifFailure ) async {
    try
    {
      await DataBase().query(
        "INSERT INTO `thumbs` (`user_id`,`loc_id`) VALUES (?,?)",
        [thumb.userId,thumb.locId]
      );
      ifSuccess();
    }
    on MySqlException catch(exc)
    {
      switch (exc.errorNumber) {
        case ER_DUP_ENTRY: 
          ifFailure("Już poleciłeś tą lokację");
          break;
        default:
          ifFailure(_unknownErrorLog(exc.toString()));
          _exceptionDebug(exc);
          break;
      }
    }
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
  }

  // by id
  static deleteComment(CommentModel com, Function ifSuccess, Function ifFailure) async {
    try
    {
      await DataBase().query( "DELETE FROM comments WHERE id = ?", [com.id] );
      ifSuccess();
    }
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
  }

  // by id
  static deleteThumb(ThumbModel thumb, Function ifSuccess, Function ifFailure) async {
    try
    {
      await DataBase().query( "DELETE FROM thumbs WHERE id = ?", [thumb.id] );
      ifSuccess();
    }
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
  }

  static createTag(String tag, Function ifSuccess, Function ifFailure) async {
    try
    {
      await DataBase().query( "INSERT INTO tags (tag) VALUES (?)", [tag] );
      ifSuccess();
    }
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    on MySqlException catch(exc){
      if(exc.errorNumber == ER_DUP_ENTRY){
        // If tag is already in database, it's ok
        ifSuccess();
      }
      else{
        ifFailure(_unknownErrorLog(exc.toString()));
        _exceptionDebug(exc);
      }

    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
  }

  static Future<TagModel> loadTag(String tag, Function ifSuccess, Function ifFailure) async {
    try
    {
      Results result =  await DataBase().query( "SELECT id FROM tags WHERE tag=?", [tag] );
      var model = TagModel( id: result.first[0], tag: tag );
      ifSuccess();
      return model;
    }
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
    return null;
  }

  static Future<bool> verifyLocation(Location loc, Function ifSuccess, Function ifFailure) async {
    try
    {
      await DataBase().query( 
        "UPDATE `locations` SET `verified`= (SELECT COUNT(*) FROM `thumbs` WHERE `loc_id` = ?) >= ? WHERE `id` = ?", 
        [loc.id,THUMBS_TO_VERIFY,loc.id]
      );
      Results result = await DataBase().query( "SELECT verified FROM locations WHERE id=?", [loc.id]);
      ifSuccess();
      return result.first[0] > 0;
    }
    on SocketException {
      ifFailure("Nie udało się połączyć z bazą danych, sprawdź połączenie internetowe");      
    }
    catch(exc)
    {
      ifFailure(_unknownErrorLog(exc.toString()));
      _exceptionDebug(exc);
    }
    return null;
  }

}