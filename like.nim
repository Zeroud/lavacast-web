import os, strutils, json

proc preLike(whoIs: string, whereIs: int) =
    var nigger = readFile("data/likes.json").parseJson{"entities"}.getElems
    var likeIt = false
    if nigger.len - 1 < whereIs:
        var напиздел = true
        for kind, ite in walkDir("public/neurohell"):
            let maga = ite.replace(".jpg", "").parseInt
            if maga == whereIs:
                напиздел = false
                break 
        if напиздел:
            discard
        else:
            while not nigger.len - 1 >= whereIs:
                nigger.add %*( @[] )
    
    if nigger[whereIs].getElems.contains(whoIs):
        likeIt = true
    else:
        likeIt = false
        
    block:
        let temp = open("data/temp", fmAppend)
        temp.write($whereIs & " " & whoIs & " " & $likeIt & "\n")
        temp.close()


proc postLike():
  let likeList = readFile(data/temp).splitLines().mapIt(it.split(" "))
  var mainFile = parseJson(readfile("data/likes.json"))
  for like in likeList:
    if not like[2].parseBool():
      mainFile[ like[0].parseInt() ] = mainFile[ like[0].parseInt() ].keepIf(proc(x: string):bool = x != like[1] )
    else:
      mainFile[ like[0].parseInt() ].add like[1]
  open("data/temp", fmWrite).close()
  
  block:
    let temp = open("data/likes.json", fmWrite)
    temp.write ($mainFile).toPretty
    temp.close()