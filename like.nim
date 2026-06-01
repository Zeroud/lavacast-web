import os, strutils, json, sequtils, sugar

proc preLike*(whoIs: string, whereIs: int) =
    var nigger = readFile("data/likes.json").parseJson{"entities"}.getElems
    var likeIt = false
    if nigger.len - 1 < whereIs:
        var напиздел = true
        for kind, ite in walkDir("public/neurohell"):
            let maga = ite.replace(".jpg", "").replace("public\\neurohell\\", "").parseInt
            echo maga
            if maga == whereIs:
                напиздел = false
                break 
        if напиздел:
            echo "умри"
            discard
        else:
            echo "не умри"
            while nigger.len - 1 <= whereIs:
                echo "добавляем к " & $nigger.len
                nigger.add %*( @[] )
    echo "считай"
    if nigger[whereIs].getElems.mapIt(it.getStr).contains(whoIs):
        likeIt = false
    else:
        likeIt = true
        
    block:
        let temp = open("data/temp", fmAppend)
        temp.write($whereIs & " " & whoIs & " " & $likeIt & "\n")
        temp.close()


proc postLike*() = 
  echo "ЭЙ Я РАБОТАЮ"
  let likeList = readFile("data/temp").splitLines().mapIt(it.split(" "))
  var mainFile = parseJson(readfile("data/likes.json")).getElems
  for like in likeList:
    if like.len != 3:
      echo "Неверный формат строки лайка: " & like.join(" ")
      continue
    echo like
    let key = like[0].parseInt()
    let userName = like[1]
    while mainFile.len - 1 < key:
        mainFile.add %*( @[] )
    if not like[2].parseBool():
      mainFile[key] = %* mainFile[key].getElems.filter(proc(x: JsonNode):bool = x.getStr != userName )
    else:
      mainFile[key].add (%* userName)
  open("data/temp", fmWrite).close()
  
  block:
    echo "sav"
    let temp = open("data/likes.json", fmWrite)
    temp.write $((%* mainFile).pretty())
    temp.close()