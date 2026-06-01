import jester,  random, os, strutils, sequtils

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
            postLike()
          except Exception as e:
            echo "бля"
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
          try:
            postLike()
          except Exception as e:
            echo "бля"
          try:
            let page = 1
            # папка с картинками
            var files: seq[string] = @[]
            for kind, path in walkDir("public/neurohell/"):
              if kind == pcFile:
                files.add(extractFilename(path))

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
              <form method='get' action='/page'>
                <button id="shuffleBtn">Перемешать</button>
              </form>
            </header>
            """

            html.add "<div class='parallax'></div>"

            html.add "<div class='grid'>"
            for img in files[0..<15]:
              html.add "<img src='neurohell/" & img & "' alt='' loading='lazy'>"
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
                for img in files[startIdx..<endIdx]:
                  html.add "<img src='/neurohell/" & img & "' alt='' loading='lazy'>"
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
            preLike(id, request.ip)
            echo "Пользователь поставил лайк картинке с ID: " & id
            resp Http200, "Лайк поставлен для картинки с ID: " & id
          except Exception as e:
            echo "ОШИБКА ЛАЙКА " & e.msg
            resp Http500, "ОШИБКА ЛАЙКА " & e.msg
          
    except Exception as e:
      echo "доктор, опять началось " & e.msg
      
      sleep(5000) 

startMess()
