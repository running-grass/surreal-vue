-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- SCOPES
-- ------------------------------

DEFINE SCOPE allusers SESSION 20w SIGNUP (CREATE user SET settings.marketing = $marketing, user = $user, pass = crypto::argon2::generate($pass), tags = $tags) SIGNIN (SELECT * FROM user WHERE user = $user AND crypto::argon2::compare(pass, $pass));

-- ------------------------------
-- TABLE: todo
-- ------------------------------

DEFINE TABLE todo SCHEMAFULL 
  PERMISSIONS 
    FOR select, create, update, delete WHERE uid = $auth.id;

DEFINE FIELD uid ON todo TYPE record(user) VALUE $auth.id ASSERT $value != NONE;
DEFINE FIELD desc ON todo TYPE string VALUE $value OR "";
DEFINE FIELD done ON todo TYPE bool VALUE $value == true OR false;
DEFINE FIELD title ON todo TYPE string VALUE $value OR "";

DEFINE FIELD deadline ON todo TYPE datetime;
DEFINE FIELD schedule.start ON todo TYPE datetime;
DEFINE FIELD schedule.end ON todo TYPE datetime;


DEFINE INDEX idx_done ON todo FIELDS done;
DEFINE INDEX idx_uid ON todo FIELDS uid;

-- ------------------------------
-- TABLE: user
-- ------------------------------

DEFINE TABLE user SCHEMAFULL 
  PERMISSIONS 
    FOR select, update WHERE id = $auth.id, 
    FOR create, delete NONE;

DEFINE FIELD pass ON user TYPE string;
DEFINE FIELD settings ON user TYPE object VALUE $value OR {};
DEFINE FIELD settings[*] ON user TYPE string;
DEFINE FIELD settings.showDone ON user TYPE bool;
DEFINE FIELD user ON user TYPE string;

DEFINE INDEX idx_user ON user FIELDS user UNIQUE;

