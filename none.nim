import jester,  random, os, strutils, sequtils

randomize()

proc startMess() =
  try:

    settings:
      port = Port(80)
      bindAddr = "0.0.0.0"

    routes:
      get "/":
        echo "мяу"
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
          html.add """<link rel='stylesheet' href='/css/style.css'>"""
          html.add """<script src='/js/script.js'></script>"""
          html.add "</head><body>"

          html.add """
          <header class="top-bar">
            <form method='get' action='/'>
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
            <form method='get' action='/""" & $(page-1) & """'>
              <button id="pageBack">Назад</button>
              <input type="hidden" name="mass" value=""" & files.join("_") & """></input>
            </form>
            <span>""" & $page & """</span>
            <form method='get' action='/""" & $(page+1) & """'>
              <button id="pageForward">Вперёд</button>
              <input type="hidden" name="mass" value=""" & files.join("_") & """></input>
            </form>
          </footer>
          """

          html.add "</body></html>"
          resp Http200, html
        except Exception as e:
          echo "ОШИБКА ДОМА " & e.msg
          resp Http500, "ОШИБКА ДОМА " & e.msg

      get "/@id":
        try:
          var html = ""

          html.add "<!DOCTYPE html><html><head>"
          html.add "<meta charset='utf-8'>"
          html.add """<link rel='stylesheet' href='/css/style.css'>"""
          html.add """<script src='/js/script.js'></script>"""
          html.add "</head><body>"

          var page: int
          try: page = @"id".parseInt()
          except Exception as e: resp Http400, "Я ТЕБЕ ЩА РУКИ ПООТРЫВАЮ " & e.msg & """
          <form method='get' action='/'><button id="shuffleBtn">Перемешать</button></form>"""

          if not request.params.hasKey("mass"):
            html.add "<h1>ВЕРНИ НА МЕСТО</h1>" & """
            <form method='get' action='/'><button id="shuffleBtn">Перемешать</button></form>"""
            resp Http200, html
          elif page < 1:
            html.add "<h1>куда собрался</h1>" & """
            <form method='get' action='/'><button id="shuffleBtn">Перемешать</button></form>"""
            resp Http200, html
          else:
            let files = request.params["mass"].split("_").toSeq()

            html.add """
            <header class="top-bar">
            <form method='get' action='/'>
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
                html.add "<img src='neurohell/" & img & "' alt='' loading='lazy'>"
            html.add "</div>"

            html.add """
            <footer class="bottom-bar">
              <form method='get' action='/""" & $ (page-1) & """'>
                <button id="pageBack">Назад</button>
                <input type="hidden" name="mass" value=""" & files.join("_") & """></input>
              </form>
              <span>""" & $page & """</span>
              <form method='get' action='/""" & $ (page+1) & """'>
                <button id="pageForward">Вперёд</button>
                <input type="hidden" name="mass" value=""" & files.join("_") & """></input>
              </form>
            </footer>
            """

            html.add "</body></html>"
            resp Http200, html
        except Exception as e:
          echo "ОШИБКА " & e.msg
          resp Http500, "ОШИБКА " & e.msg

        
  except Exception as e:
    echo "доктор, опять началось " & e.msg
    startMess()

startMess()