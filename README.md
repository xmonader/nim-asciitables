# nim-asciitables
simple terminal ascii tables for nim

## DEPRECATION
project is deprecated in favor for [nim-terminaltables](https://github.com/xmonader/nim-terminaltables)

## How to use
asciitables has a very simple api

- `setHeaders` to set column names
- `addRow` to add a row to the table
- `addRows` to add multiple rows at once
- `suggestWidths` to suggest widths for each column

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

should render
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
and to suggest widths for columns
```nim

  t.reset()
  t.suggestWidths(@[10, 80, 30])
  t.setHeaders(@["ID", "Name", "Date"])
  t.addRow(@["1", "Aaaa", "2018-10-2"])
  t.addRow(@["2", "bbvbbba", "2018-10-2"])
  t.addRow(@["399", "CCC", "1018-5-2"])
  printTable(t)


```
you will see 
```
+----------+--------------------------------------------------------------------------------+------------------------------+
|ID        |Name                                                                            |Date                          |
+----------+--------------------------------------------------------------------------------+------------------------------+
|1         |Aaaa                                                                            |2018-10-2                     |
+----------+--------------------------------------------------------------------------------+------------------------------+
|2         |bbvbbba                                                                         |2018-10-2                     |
+----------+--------------------------------------------------------------------------------+------------------------------+
|399       |CCC                                                                             |1018-5-2                      |
+----------+--------------------------------------------------------------------------------+------------------------------+
```

## Why
I couldn't find any terminal ascii table library for nim and I found myself writing horrible code like this 

```nim
      var widths = @[0,0,0,0]  #id, name, ports, root
      for k, v in info:
        if len($v.id) > widths[0]:
          widths[0] = len($v.id)
        if len($v.name) > widths[1]:
          widths[1] = len($v.name)
        if len($v.ports) > widths[2]:
          widths[2] = len($v.ports)
        if len($v.root) > widths[3]:
          widths[3] = len($v.root)
      
      var sumWidths = 0
      for w in widths:
        sumWidths += w
      
      echo "-".repeat(sumWidths)

      let extraPadding = 5
      echo "| ID"  & " ".repeat(widths[0]+ extraPadding-4) & "| Name" & " ".repeat(widths[1]+extraPadding-6) & "| Ports" & " ".repeat(widths[2]+extraPadding-6 ) & "| Root" &  " ".repeat(widths[3]-6)
      echo "-".repeat(sumWidths)
  

      for k, v in info:
        let nroot = replace(v.root, "https://hub.grid.tf/", "").strip()
        echo "|" & $v.id & " ".repeat(widths[0]-len($v.id)-1 + extraPadding) & "|" & v.name & " ".repeat(widths[1]-len(v.name)-1 + extraPadding) & "|" & v.ports & " ".repeat(widths[2]-len(v.ports)+extraPadding) & "|" & nroot & " ".repeat(widths[3]-len(v.root)+ extraPadding-2) & "|"
        echo "-".repeat(sumWidths)
      result = ""
```
Pull requests are very welcome :)
