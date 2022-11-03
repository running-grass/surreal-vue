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
    FOR select WHERE uid = $auth.id, 
    FOR create WHERE uid = $auth.id, 
    FOR update WHERE uid = $auth.id, 
    FOR delete  WHERE uid = $auth.id;
    -- FOR delete FULL;

DEFINE FIELD desc ON todo TYPE string VALUE $value OR "";
DEFINE FIELD done ON todo TYPE bool VALUE $value == true OR false;
DEFINE FIELD title ON todo TYPE string VALUE $value OR "";
DEFINE FIELD dueTime ON todo TYPE datetime;
DEFINE FIELD uid ON todo TYPE record(user) VALUE $auth.id ASSERT $value != NONE;

DEFINE INDEX idx_done ON todo FIELDS done;
DEFINE INDEX idx_uid ON todo FIELDS uid;
DEFINE INDEX idx_due_time ON todo FIELDS dueTime;

-- ------------------------------
-- TABLE: user
-- ------------------------------

DEFINE TABLE user SCHEMAFULL 
  PERMISSIONS 
    FOR select WHERE id = $auth.id, 
    FOR create NONE, 
    FOR update WHERE id = $auth.id, 
    FOR delete NONE;

DEFINE FIELD pass ON user TYPE string;
DEFINE FIELD settings ON user TYPE object VALUE $value OR {};
DEFINE FIELD settings[*] ON user TYPE string;
DEFINE FIELD settings.showDone ON user TYPE bool;
DEFINE FIELD user ON user TYPE string;

DEFINE INDEX idx_user ON user FIELDS user UNIQUE;

