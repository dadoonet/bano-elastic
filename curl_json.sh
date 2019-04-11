while read a; do
  curl -s -XPOST "localhost:8080" -H "Content-Type: application/json" -d "{\"message\": \"$a\"}" -o /dev/null
done

