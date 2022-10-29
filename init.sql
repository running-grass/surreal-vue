OPTION IMPORT;

DEFINE SCOPE allusers SESSION 20w SIGNUP (CREATE user SET settings.marketing = $marketing, user = $user, pass = crypto::argon2::generate($pass), tags = $tags) SIGNIN (SELECT * FROM user WHERE user = $user AND crypto::argon2::compare(pass, $pass));

DEFINE TABLE user SCHEMAFULL PERMISSIONS FOR select WHERE id = $auth.id, FOR create NONE, FOR update WHERE id = $auth.id, FOR delete NONE;
DEFINE FIELD pass ON user TYPE string;
DEFINE FIELD settings ON user TYPE object;
DEFINE FIELD settings.showDone ON user TYPE bool VALUE $value OR true;
DEFINE FIELD settings[*] ON user TYPE string;
DEFINE FIELD user ON user TYPE string;
DEFINE INDEX idx_user ON user FIELDS user UNIQUE;

DEFINE TABLE todo SCHEMAFULL PERMISSIONS FOR select , create, update, delete WHERE uid = $auth.id;
DEFINE FIELD uid ON todo TYPE record(user) VALUE $auth.id ASSERT $value != NONE;
DEFINE FIELD title ON todo TYPE string VALUE $value OR "";
DEFINE FIELD desc ON todo TYPE string VALUE $value OR "";
DEFINE FIELD done ON todo TYPE bool VALUE $value OR false;

DEFINE INDEX idx_done ON user FIELDS done;

BEGIN TRANSACTION;
UPDATE user:testuser CONTENT { id: user:testuser, pass: "$argon2id$v=19$m=4096,t=3,p=1$vvd5F1VNnzVN4vcgKfNgZg$g2sQCFRjZ7W/CyDV+JuE16tEbEjcDp8fGxlb6CocEAs", settings: { marketing: "cn" }, tags: [], user: "testuser" };
COMMIT TRANSACTION;