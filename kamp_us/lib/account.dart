import 'package:password_hash/password_hash.dart';

class Account {
    static final PBKDF2 _generator = new PBKDF2();
    static final String _salt = Salt.generateAsBase64String(32);
    String _nickname;
    String _email;
    String _passwd;

    Account.login(this._email, String passwd, [this._nickname]) {
      _passwd = _generator.generateKey(_passwd, _salt, 1000, 32);
    }
    Account.model(accoun)

}