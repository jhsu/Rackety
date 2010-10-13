# Rackety

Simple rack server that returns contents of files. Useful for dummy apps for
testing api connectors.

## GET

1. Place files in the same directory (ie. filename.json)
2. `rackup`
3. open `http://localhost:9292/filename.json`

## POST

1. Using curl: `curl -d "hello=bye" http://localhost:9292/` or upload a file
   with `curl -F file=@test.json http://localhost:9292/`
2. returns params (TODO: return a specified file ie. JSON)
