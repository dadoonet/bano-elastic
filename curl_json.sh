while read a; do
  curl -s -XPOST "127.0.0.1:8000" -H "Content-Type: application/json" -d "{\"message\": \"$a\"}" -o /dev/null
done

