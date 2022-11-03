set -e

DATA=`cat /scripts/init.sql`
curl  --request POST \
      --header "Accept: application/json" \
      --header "NS: test" \
      --header "DB: test" \
      --user "${DB_USER}:${DB_PASS}" \
      --data "${DATA}" \
      http://db:8000/sql

nginx -g 'daemon off;'