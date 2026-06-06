import os, strutils, json, sequtils, sugar

proc preLike*(whoIs: string, whereIs: int) =
    let jsonData = parseJson(readFile("data/likes.json"))
    var nigger = if jsonData.hasKey("entities"): jsonData{"entities"}.getElems else: jsonData.getElems
    var likeIt = false
    if nigger.len - 1 < whereIs:
        var напиздел = true
        for kind, ite in walkDir("public/neurohell"):
            let maga = ite.replace(".jpg", "").replace("public\\neurohell\\", "").parseInt
            if maga == whereIs:
                напиздел = false
                break 
        if напиздел:
            discard
        else:
            while nigger.len - 1 < whereIs:
                echo "добавляем к " & $nigger.len
                nigger.add %*( @[] )
    if nigger[whereIs].getElems.mapIt(it.getStr).contains(whoIs):
        likeIt = false
    else:
        likeIt = true
        
    block:
        let temp = open("data/temp", fmAppend)
        temp.write($whereIs & " " & whoIs & " " & $likeIt & "\n")
        temp.close()


proc postLike*() = 
  let likeList = readFile("data/temp").splitLines().mapIt(it.split(" ")).deduplicate
  let originalJson = parseJson(readfile("data/likes.json"))
  var mainFile = if originalJson.hasKey("entities"): originalJson{"entities"}.getElems else: originalJson.getElems
  for like in likeList:
    if like.len != 3:
      continue
    let key = like[0].parseInt()
    let userName = like[1]
    while mainFile.len - 1 < key:
        mainFile.add %*( @[] )
    if not like[2].parseBool():
      mainFile[key] = %* mainFile[key].getElems.filterIt(it.getStr != userName )
    else:
      if not mainFile[key].getElems.mapIt(it.getStr).contains(userName):
        mainFile[key].add (%* userName)
  open("data/temp", fmWrite).close()
  
  block:
    echo "sav"
    let temp = open("data/likes.json", fmWrite)
    let resultJson = if originalJson.hasKey("entities"): %* { "entities": mainFile } else: %* mainFile
    temp.write $(resultJson.pretty())
    temp.close()