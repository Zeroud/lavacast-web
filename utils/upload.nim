import httpClient, json, os

createDir("pic")

let sous = newHttpClient()
sous.headers = newHttpHeaders {"Content-Type": "application/json"}

var xix = sous.request("https://lavacast.ru/api").body.parseJson{"lastImg"}.getInt + 1
for kind, path in walkDir("pic"):
  if kind == pcFile:
    moveFile(path, "pic/" & $xix & ".jpg")
    xix += 1

close sous