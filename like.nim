import os, strutils, json

proc preLike(whoIs: string, whereIs: int) =
    var nigger = readFile("data/likes.json").parseJson{"entities"}.getElems
    var likeIt = false
    if nigger.len - 1 < whereIs:
        for kind, ite in walkDir("public/neurohell"):
            let maga = ite.replace(".jpg", "").parseInt
            if maga == whereIs:
                break 
    else:
        if nigger[whereIs].getElems.contains(whoIs):
            likeIt = true
    open("data/temp", fmAppend).write($whereIs & " " & whoIs & " " & $likeIt & "\n")