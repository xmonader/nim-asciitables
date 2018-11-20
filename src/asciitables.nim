import strformat, strutils


type Cell = object
  leftpad*: int
  rightpad: int
  pad*: int
  text*: string

proc newCell(text: string, leftpad=1, rightpad=1, pad=0): ref Cell =
  result = new Cell
  result.pad = pad

  if pad != 0:
    result.leftpad = pad
    result.rightpad = pad
  else:
    result.leftpad = leftpad
    result.rightpad = rightpad
  result.text = text


proc newCellFromAnother(another: ref Cell): ref Cell =
  result = newCell(text=another.text, leftpad=another.leftpad, rightpad=another.rightpad)


proc len*(this:ref Cell): int =
  result = this.leftpad + this.text.len + this.rightpad

proc `$`*(this:ref Cell): string =
  result = " ".repeat(this.leftpad) & this.text & " ".repeat(this.rightpad)

type AsciiTable = object 
  rows: seq[seq[string]]
  headers: seq[ref Cell]
  rowSeparator*: string
  colSeparator*: string 
  cellEdge*: string
  widths: seq[int]
  suggestedWidths: seq[int]
  tableWidth*: int
  separateRows*: bool


proc newAsciiTable*(): ref AsciiTable =
  result = new AsciiTable
  result.rowSeparator="-"
  result.colSeparator="|"
  result.cellEdge="+"
  result.tableWidth=0
  result.separateRows=true
  result.widths = newSeq[int]()
  result.suggestedWidths = newSeq[int]()
  result.rows = newSeq[seq[string]]()
  result.headers = newSeq[ref Cell]()

proc columnsCount*(this: ref AsciiTable): int =
  result = this.headers.len

proc setHeaders*(this: ref AsciiTable, headers:seq[string]) =
  for s in headers:
    var cell = newCell(s)
    this.headers.add(cell)

proc setHeaders*(this: ref AsciiTable, headers: seq[ref Cell]) = 
  this.headers = headers

proc setRows*(this: ref AsciiTable, rows:seq[seq[string]]) =
  this.rows = rows

proc addRow*(this: ref AsciiTable, row:seq[string]) =
  this.rows.add(row)

proc suggestWidths*(this: ref AsciiTable, widths:seq[int]) = 
  this.suggestedWidths = widths

proc reset*(this:ref AsciiTable) =
  this.rowSeparator="-"
  this.colSeparator="|"
  this.cellEdge="+"
  this.tableWidth=0
  this.separateRows=true
  this.widths = newSeq[int]()
  this.suggestedWidths = newSeq[int]()
  this.rows = newSeq[seq[string]]()
  this.headers = newSeq[ref Cell]()

proc calculateWidths(this: ref AsciiTable) =
  var colsWidths = newSeq[int]()
  if this.suggestedWidths.len == 0:
    for h in this.headers:
      colsWidths.add(h.len) 
  else:
    colsWidths = this.suggestedWidths
  
  for row in this.rows:
    for colpos, c in row:
      var acell = newCellFromAnother(this.headers[colpos])
      acell.text = c
      if len(acell) > colsWidths[colpos]:
        colsWidths[colpos] = len(acell)

  let sizeForCol = (this.tablewidth/len(this.headers)).toInt()
  var lenHeaders = 0
  for w in colsWidths:
    lenHeaders += w 

  if this.tablewidth > lenHeaders:
    if this.suggestedWidths.len == 0:
      for colpos, c in colsWidths:
        colsWidths[colpos] += sizeForCol - c

  this.widths = colsWidths
  
proc oneLine(this: ref AsciiTable): string =
  result &= this.cellEdge
  for w in this.widths:
    result &= "-".repeat(w) & this.cellEdge
  result &= "\n"

proc render*(this: ref AsciiTable): string =
  this.calculateWidths()
  # top border
  result &= this.oneline()
  
  # headers
  for colidx, h in this.headers:
    result &= this.colSeparator & $h & " ".repeat(this.widths[colidx]-len(h) )
  
  result &= this.colSeparator
  result &= "\n"
  # finish headers 

  # line after headers
  result &= this.oneline()

  # start rows
  for r in this.rows:
    # start row
    for colidx, c in r:
      let cell = newCell(c, leftpad=this.headers[colidx].leftpad, rightpad=this.headers[colidx].rightpad)
      result &= this.colSeparator & $cell & " ".repeat(this.widths[colidx]-len(cell)) 
    result &= this.colSeparator
    result &= "\n"
    if this.separateRows: 
        result &= this.oneLine()
    # finish row
  
  # don't duplicate the finishing line if it's already printed in case of this.separateRows
  if not this.separateRows:
      result &= this.oneLine()
  return result

proc printTable*(this: ref AsciiTable) =
  echo(this.render())

when not defined(js):
  import os, osproc
  proc termColumns(): int =
    if os.existsEnv("COLUMNS") and getEnv("COLUMNS").isDigit():
        return parseInt(getEnv("COLUMNS"))
    else:
      if findExe("tput") != "":
        let (cols, rc) = execCmdEx("tput cols")
        if rc == 0:
          return cols.strip().parseInt()
      if findExe("stty") != "":
        let (output, rc) = execCmdEx("stty size")
        if rc == 0:
          let parts = output.splitWhitespace()
          if len(parts) == 2:
            return parts[1].strip().parseInt()
    return 0


when isMainModule:

  var t = newAsciiTable()
  echo "termColumns: " & $termColumns()

  # width of the table is the terminal COLUMNS - the amount of separators (columns + 1)  multiplied by length of the separator
  t.tableWidth = termColumns() - (t.columnsCount() * len(t.colSeparator)) - 1 - 5
  t.setHeaders(@["ID", "Name", "Fav animal", "Date", "OK"])
  t.addRow(@["1", "xmonader", "Cat, Dog", "2018-10-2", "yes"])
  t.addRow(@["2", "ahmed", "Shark", "2018-10-2", "yes"])
  t.addRow(@["3", "dr who", "Humans", "1018-5-2", "no"])
  printTable(t)
  
  t.tableWidth = 0
  printTable(t)

  t.tableWidth = 0
  t.separateRows = false
  printTable(t)

  t.reset()
  t.suggestWidths(@[10, 20, 60, 10])
  t.setHeaders(@["ID", "Name", "Fav animal", "Date"])
  t.addRow(@["1", "xmonader", "Cat, Dog", "2018-10-22"])
  t.addRow(@["2", "ahmed", "Shark", "2015-12-6"])
  t.addRow(@["3", "dr who", "Humans", "1018-5-2"])
  printTable(t)