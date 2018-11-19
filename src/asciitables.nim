import strformat, strutils


type AsciiTable = object 
  rows: seq[seq[string]]
  headers: seq[string]
  rowSeparator*: string
  colSeparator*: string 
  cellEdge*: string
  widths: seq[int]
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
  result.rows = newSeq[seq[string]]()
  result.headers = newSeq[string]()

proc setHeaders*(this: ref AsciiTable, headers:seq[string]) =
  this.headers = headers

proc setRows*(this: ref AsciiTable, rows:seq[seq[string]]) =
  this.rows = rows

proc addRow*(this: ref AsciiTable, row:seq[string]) =
  this.rows.add(row)

proc calculateWidths(this: ref AsciiTable) =
  var colsWidths = newSeq[int]()
  for i in countup(1, this.headers.len):
    colsWidths.add(0) 

  
  for row in this.rows:
    for colpos, c in row:
      if len(c) > colsWidths[colpos]:
        colsWidths[colpos] = len(c)
      
  let sizeForCol = (this.tablewidth/len(this.headers)).toInt()
  var lenHeaders = 0
  for h in this.headers:
    lenHeaders += h.len()

  if this.tablewidth > lenHeaders:
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
      result &= this.colSeparator & h & " ".repeat(this.widths[colidx]-len(h) )
  result &= this.colSeparator
  result &= "\n"

  # line after headers
  result &= this.oneline()

  for r in this.rows:
    for colidx, c in r:
      result &= this.colSeparator & c & " ".repeat(this.widths[colidx]-len(c)) 
    result &= this.colSeparator
    result &= "\n"
    if this.separateRows: 
        result &= this.oneLine()
  if not this.separateRows:
      result &= this.oneLine()
  return result

proc printTable*(this: ref AsciiTable) =
  echo(this.render())

when isMainModule:
  var t = newAsciiTable()
  t.tableWidth = 80
  t.setHeaders(@["ID", "Name", "Date"])
  t.addRow(@["1", "Aaaa", "2018-10-2"])
  t.addRow(@["2", "bbvbbba", "2018-10-2"])
  t.addRow(@["399", "CCC", "1018-5-2"])
  printTable(t)
  
  t.tableWidth = 0
  printTable(t)

  t.tableWidth = 0
  t.separateRows = false
  printTable(t)