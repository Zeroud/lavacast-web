import jester,  random, os, strutils, sequtils, algorithm, like, json, sugar

randomize()

proc startMess() =
  while true:
    try:

      settings:
        port = Port(8080)
        bindAddr = "0.0.0.0"

      routes:
        get "/":
          echo "мяу"
          try:
            resp Http200, """
            <!DOCTYPE html><html><head>
            <meta charset='utf-8'>
            <link rel='icon' href='/SoUSchitecture.png' type='image/png'>
            <link rel='stylesheet' href='/css/main.css'>
            <meta name='description' content='Lavacast - галерея искусственного интеллекта и фигня какая-то. Уникальная коллекция'>
            <meta name='keywords' content='AI, искусственный интеллект, галерея, neuroslop, FlionGame, креветочный Иисус, соус, sous, lavacast, лавакаст'>
            <meta name='author' content='zeroud_'>
            <title>lavacast</title>
            </head><body>

            <form method='get' action='/page'>
              <button id="neurohellBtn">ИИ галерея</button>
            </form>

            <form method='get' action='/FlionGame'>
              <button id="flionGameBtn">FlionGame</button>
            </form>

            <footer class="bottom-bar">
              <span>© 2077 zeroud_. Все права отсутствуют.</span>
            </footer>
            </body></html>
            """
          except Exception as e:
            echo "ОШИБКА ГЛАВНОЙ " & e.msg
            resp Http500, "ОШИБКА " & e.msg & " ПРАВА ПРАВА ГДЕ ВСЕ МОИ ПРАВА"
        get "/page":

          let realIp =
            if request.headers.hasKey("X-Forwarded-For"):
              request.headers["X-Forwarded-For"].split(",")[0].strip()
            elif request.headers.hasKey("X-Real-IP"):
              request.headers["X-Real-IP"]
            else: $request.ip

          try:
            postLike()
          except Exception as e:
            echo "бля " & e.msg 
          try:
            let page = 1
            # папка с картинками
            var files: seq[string] = @[]
            for kind, path in walkDir("public/neurohell/"):
              if kind == pcFile:
                files.add(extractFilename(path))

            let dataIs: seq[int] = readFile("data/likes.json").parseJson(){"entities"}.getElems().mapIt(it.getElems().len)
            var dataFiles: seq[string] = toSeq(0..(dataIs.len-1)).sortedByIt(-dataIs[it]).mapIt($it)


            files.shuffle()

            var html = ""

            html.add "<!DOCTYPE html><html><head>"
            html.add "<meta charset='utf-8'>"
            html.add"""<link rel='icon' href='/SoUSchitecture.png' type='image/png'>
            <link rel='stylesheet' href='/css/main.css'>
            <meta name='description' content='Lavacast - галерея искусственного интеллекта и фигня какая-то. Уникальная коллекция'>
            <meta name='keywords' content='AI, искусственный интеллект, галерея, neuroslop, FlionGame, креветочный Иисус, соус, sous, lavacast, лавакаст'>
            <meta name='author' content='zeroud_'>
            <title>lavacast</title>"""
            html.add """<link rel='stylesheet' href='/css/style.css'>"""
            html.add """<script src='/js/script.js'></script>"""
            html.add "</head><body>"

            html.add """
            <header class="top-bar">
              <form method='get' action='/page/1'>
                <button id="bestBtn">Лучшие</button>
                <input type="hidden" name="mass" value=""" & dataFiles.join("_") & """></input>
              </form>
              <form method='get' action='/page/1'>
                <button id="worstBtn">Худшие</button>
                <input type="hidden" name="mass" value=""" & dataFiles.reversed().join("_") & """></input>
              </form>
            </header>
            """

            html.add "<div class='parallax'></div>"

            html.add "<div class='grid'>"
            for idx, img in files[0..<15]:
              let imgId = img.replace(".jpg", "")
              var jsonData: string
              var liked = false
              try:
                let datax = parseJson(readFile("data/likes.json")){"entities"}.getElems()
                jsonData = if datax.len > imgId.parseInt: $datax[imgId.parseInt].len else: "0"
                if datax[imgId.parseInt].getElems().mapIt(it.getStr()).contains(realIp):
                      liked = true
              except Exception as e:
                jsonData = e.msg
              html.add "<div class='image-container'>"
              html.add "<img src='/neurohell/" & img & "' alt='' loading='lazy' id='" & $idx & "'>"
              html.add """
              <form method='post' action='/like/""" & imgId & """'>
                <button id='like-btn' data-active='""" & $(liked) & """'>♥ """ & jsonData & """</button>
                <input type="hidden" name="mass" value=""" & files.mapIt(it.replace(".jpg", "")).join("_") & """></input>
              </form>
              """
              html.add "</div>"
            html.add "</div>"

            html.add """
            <footer class="bottom-bar">
              <span>""" & $page & """</span>
              <form method='get' action='/page/""" & $(page+1) & """'>
                <button id="pageForward">Вперёд</button>
                <input type="hidden" name="mass" value=""" & files.mapIt(it.replace(".jpg", "")).join("_") & """></input>
              </form>
            </footer>
            """
            html.add "</body></html>"
            resp Http200, html
          except Exception as e:
            echo "ОШИБКА ДОМА " & e.msg
            resp Http500, "ОШИБКА ДОМА " & e.msg
        get "/FlionGame/download":
          try:
            let path = "./FlionGame.zip"
            let data = readFile(path)  # бинарно-безопасно

            resp Http200,
              {
                "Content-Type": "application/zip",
                "Content-Disposition": "attachment; filename=\"FlionGame.zip\"",
                "Cache-Control": "no-store"
              },
              data
          except Exception as e:
            resp Http500, "ОШИБКА СКАЧИВАНИЯ " & e.msg
        get "/FlionGame":
          try:
            resp Http200, """
            <!DOCTYPE html><html><head>
            <meta charset='utf-8'>
            <link rel='icon' href='/SoUSchitecture.png' type='image/png'>
            <link rel='stylesheet' href='/css/main.css'>
            <meta name='author' content='zeroud_'>
            <title>FlionGame</title>
            </head><body>
            <iframe frameborder="0" src="https://itch.io/embed/4454355" width="552" height="167"><a href="https://zeroud.itch.io/fliongame">FlionGame by zeroud_</a></iframe>
            <button id="downloadBtn"><a href="/FlionGame/download" style="color: inherit; text-decoration: none;">Скачать напрямую</a></button>
            </body></html>
            """
          except Exception as e:
            echo "ОШИБКА FLIONGAME " & e.msg
            resp Http500, "ОШИБКА FLIONGAME " & e.msg
        get "/page/@id":
          try:
            postLike()
          except Exception as e:
            echo "бля"
          try:

            let realIp =
              if request.headers.hasKey("X-Forwarded-For"):
                request.headers["X-Forwarded-For"].split(",")[0].strip()
              elif request.headers.hasKey("X-Real-IP"):
                request.headers["X-Real-IP"]
              else: $request.ip

            var html = ""

            html.add "<!DOCTYPE html><html><head>"
            html.add "<meta charset='utf-8'>"
            html.add"""<link rel='icon' href='/SoUSchitecture.png' type='image/png'>
            <link rel='stylesheet' href='/css/main.css'>
            <meta name='description' content='Lavacast - галерея искусственного интеллекта и фигня какая-то. Уникальная коллекция'>
            <meta name='keywords' content='AI, искусственный интеллект, галерея, neuroslop, FlionGame, креветочный Иисус, соус, sous, lavacast, лавакаст'>
            <meta name='author' content='zeroud_'>
            <title>lavacast</title>"""
            html.add """<link rel='stylesheet' href='/css/style.css'>"""
            html.add """<script src='/js/script.js'></script>"""
            html.add "</head><body>"

            var page: int
            try: page = @"id".parseInt()
            except Exception as e: resp Http400, "Я ТЕБЕ ЩА РУКИ ПООТРЫВАЮ " & e.msg & """
            <form method='get' action='/'><button id="shuffleBtn">Вернуться</button></form>"""

            if not request.params.hasKey("mass"):
              html.add "<h1>ВЕРНИ НА МЕСТО</h1>" & """
              <form method='get' action='/'><button id="shuffleBtn">Вернуться</button></form>"""
              resp Http200, html
            elif page < 1:
              html.add "<h1>куда собрался</h1>" & """
              <form method='get' action='/page'><button id="shuffleBtn">Вернуться</button></form>"""
              resp Http200, html
            else:
              let files = request.params["mass"].split("_").toSeq().mapIt(it & ".jpg")

              html.add """
              <header class="top-bar">
              <form method='get' action='/page'>
                  <button id="shuffleBtn">Перемешать</button>
              </form>
              </header>
              """

              html.add "<div class='parallax'></div>"

              html.add "<div class='grid'>"

              let startIdx = (page-1)*15
              let endIdx = if page*15 > files.len: files.len else: page*15

              if startIdx < files.len and startIdx >= 0:
                for idx, img in files[startIdx..<endIdx]:
                  let imgId = img.replace(".jpg", "")
                  var jsonData: string
                  var liked = false
                  try:
                    let datax:seq[JsonNode] = parseJson(readFile("data/likes.json")){"entities"}.getElems()
                    jsonData = if datax.len > imgId.parseInt: $datax[imgId.parseInt].getElems().len else: "0"
                    if datax[imgId.parseInt].getElems().mapIt(it.getStr()).contains(realIp):
                      liked = true
                  except Exception as e:
                    jsonData = e.msg
                  html.add "<div class='image-container'>"
                  html.add "<img src='/neurohell/" & img & "' alt='' loading='lazy' id='" & $idx & "'>"
                  html.add """
                  <form method='post' action='/like/""" & imgId & """'>
                    <button id='like-btn' data-active='""" & $(liked) & """'>♥ """ & jsonData & """</button>
                    <input type="hidden" name="mass" value=""" & files.mapIt(it.replace(".jpg", "")).join("_") & """></input>
                  </form>
                  """
                  html.add "</div>"
              html.add "</div>"

              html.add """
              <footer class="bottom-bar">
                <form method='get' action='/page/""" & $(page-1) & """'>
                  <button id="pageBack">Назад</button>
                  <input type="hidden" name="mass" value=""" & files.mapIt(it.replace(".jpg", "")).join("_") & """></input>
                </form>
                <span>""" & $page & """</span>
                <form method='get' action='/page/""" & $(page+1) & """'>
                  <button id="pageForward">Вперёд</button>
                  <input type="hidden" name="mass" value=""" & files.mapIt(it.replace(".jpg", "")).join("_") & """></input>
                </form>
              </footer>
              """

              html.add "</body></html>"
              resp Http200, html
          except Exception as e:
            echo "ОШИБКА " & e.msg
            resp Http500, "ОШИБКА " & e.msg
        post "/like/@id":
          try:
            let id = @"id"
            let realIp =
              if request.headers.hasKey("X-Forwarded-For"):
                request.headers["X-Forwarded-For"].split(",")[0].strip()
              elif request.headers.hasKey("X-Real-IP"):
                request.headers["X-Real-IP"]
              else: $request.ip
            if  request.params["mass"].split("_").mapIt(it.parseInt).max < id.parseInt:
              resp Http406, "не-а" & """
              <form method='get' action='/'><button id="shuffleBtn">Вернуться</button></form>"""
            preLike($realIp, id.parseInt)
            redirect("/page/" & $(((request.params["mass"].split("_").findIt(it == id) ) div 15) + 1) & "?mass=" & request.params["mass"] & "#" & $(request.params["mass"].split("_").findIt(it == id) %% 15) )
          except Exception as e:
            echo "ОШИБКА ЛАЙКА " & e.msg
            resp Http500, "ну что ты наделал " & e.msg 
          
    except Exception as e:
      echo "доктор, опять началось " & e.msg
      
      sleep(5000) 

startMess()
