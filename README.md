# nim-asciitables
simple terminal ascii tables for nim

## How to use
asciitables has a very simple api

1- `setHeaders` to set column names
2- `addRow` to add a row to the table
3- `addRows` to add multiple rows at once

### options and styles
- cellEdge controls the the corners of each cell default is `+`
- colSeparator is the separator after each column set to `|` by default
- rowSeparator is the separator between rows and is set to `-` by default 
- separateRows is option to add a row separator after rendering each row or not.

## Examples

```nim


when isMainModule:
  var t = newAsciiTable()
  t.tableWidth = 80
  t.setHeaders(@["ID", "Name", "Date"])
  t.addRow(@["1", "Aaaa", "2018-10-2"])
  t.addRow(@["2", "bbvbbba", "2018-10-2"])
  t.addRow(@["399", "CCC", "1018-5-2"])
  printTable(t)


```

should yield
```
+---------------------------+---------------------------+---------------------------+
|ID                         |Name                       |Date                       |
+---------------------------+---------------------------+---------------------------+
|1                          |Aaaa                       |2018-10-2                  |
+---------------------------+---------------------------+---------------------------+
|2                          |bbvbbba                    |2018-10-2                  |
+---------------------------+---------------------------+---------------------------+
|399                        |CCC                        |1018-5-2                   |
+---------------------------+---------------------------+---------------------------+

```

```nim
  t.tableWidth = 0
  printTable(t)
```
```
+---+-------+---------+
|ID |Name   |Date     |
+---+-------+---------+
|1  |Aaaa   |2018-10-2|
+---+-------+---------+
|2  |bbvbbba|2018-10-2|
+---+-------+---------+
|399|CCC    |1018-5-2 |
+---+-------+---------+
```

and if you don't want `separateRows` 

```nim
  t.tableWidth = 0
  t.separateRows = false
  printTable(t)

```

```nim
+---+-------+---------+
|ID |Name   |Date     |
+---+-------+---------+
|1  |Aaaa   |2018-10-2|
|2  |bbvbbba|2018-10-2|
|399|CCC    |1018-5-2 |
+---+-------+---------+
```