OPTION IMPORT;

DEFINE SCOPE allusers SESSION 2w SIGNUP (CREATE user SET settings.marketing = $marketing, user = $user, pass = crypto::argon2::generate($pass), tags = $tags) SIGNIN (SELECT * FROM user WHERE user = $user AND crypto::argon2::compare(pass, $pass));

DEFINE TABLE user SCHEMAFULL PERMISSIONS FOR select WHERE id = $auth.id, FOR create NONE, FOR update WHERE id = $auth.id, FOR delete NONE;
DEFINE FIELD pass ON user TYPE string;
DEFINE FIELD settings.marketing ON user TYPE string;
DEFINE FIELD settings[*] ON user TYPE string;
DEFINE FIELD tags ON user TYPE array;
DEFINE FIELD tags[*] ON user TYPE string
DEFINE FIELD user ON user TYPE string;
DEFINE INDEX idx_user ON user FIELDS user UNIQUE;

DEFINE TABLE todo SCHEMAFULL PERMISSIONS FOR select , create, update, delete WHERE uid = $auth.id;
DEFINE FIELD uid ON todo TYPE record(user) VALUE $auth.id ASSERT $value != NONE;
DEFINE FIELD title ON todo TYPE string VALUE $value OR "";
DEFINE FIELD desc ON todo TYPE string VALUE $value OR "";
DEFINE FIELD done ON todo TYPE bool VALUE $value OR false;

DEFINE INDEX idx_done ON user FIELDS done;

BEGIN TRANSACTION;
UPDATE user:grass CONTENT { id: user:grass, pass: "$argon2id$v=19$m=4096,t=3,p=1$0BExS0HckcuLAlnXj9sJ6Q$W+ozbHHjnMzu4Jk0HY/IaUjI4g6OwpP4f0ulEwyyKf4", settings: { marketing: "cn" }, tags: [], user: "grass" };
COMMIT TRANSACTION;