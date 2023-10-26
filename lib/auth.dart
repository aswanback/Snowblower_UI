library ui_463.globals;

class Cred {
  String username = '';
  String password = '';
  String? robotId;

  Cred.empty();
  Cred(this.username, this.password, this.robotId);
}

class CredentialChecker {
  Map<String, Cred> credentials = {
    'andrew': Cred('andrew', 'root', '1234'),
  };

  bool register(Cred cred) {
    if (credentials.containsKey(cred.username)) {
      // account exists already
      return false;
    }
    if (credentials.values.map((e) => e.robotId).contains(cred.robotId)) {
      // robot registered already
      return false;
    }
    // make new entry
    credentials[cred.username] = cred;
    return true;
  }

  bool login(Cred cred) {
    return credentials[cred.username]?.password == cred.password;
  }
}

CredentialChecker credCheck = CredentialChecker();
