import 'package:kamp_us/models.dart';
import 'package:password_hash/password_hash.dart';

// DODAĆ SZYFROWANIE HASEŁ !!!!!

class Account {
    static final PBKDF2 _generator = new PBKDF2();
    static final String _salt = Salt.generateAsBase64String(32);
    String _nickname;
    String _email;
    String _passwd;

    Account.login(this._email, this._passwd, [this._nickname]);
    Account.model( AccountModel model )
    {
      _nickname = model.nickname;
      _email = model.email;
      _passwd = model.passwd;
    }

}