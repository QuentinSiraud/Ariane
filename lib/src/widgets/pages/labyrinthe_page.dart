import 'package:flutter/material.dart';

// Ajoute cette énumération pour le chemin trouvé
enum CellType { empty, wall, start, end, path }

class LabyrinthePage extends StatefulWidget {
  const LabyrinthePage({Key? key}) : super(key: key);

  @override
  State<LabyrinthePage> createState() => _LabyrinthePageState();
}

class _LabyrinthePageState extends State<LabyrinthePage> {
  static const int rows = 10;
  static const int cols = 16;
  List<List<CellType>> grid = List.generate(
    rows,
    (_) => List.generate(cols, (_) => CellType.empty),
  );

  CellType selectedType = CellType.wall;
  Offset? start;
  Offset? end;

  void _onCellTap(int row, int col) {
    setState(() {
      if (selectedType == CellType.start) {
        // Remove previous start
        if (start != null) {
          grid[start!.dx.toInt()][start!.dy.toInt()] = CellType.empty;
        }
        start = Offset(row.toDouble(), col.toDouble());
      }
      if (selectedType == CellType.end) {
        // Remove previous end
        if (end != null) {
          grid[end!.dx.toInt()][end!.dy.toInt()] = CellType.empty;
        }
        end = Offset(row.toDouble(), col.toDouble());
      }
      grid[row][col] = selectedType;
    });
  }

  void _solveMaze() {
    if (start == null || end == null) return;

    // BFS
    final queue = <List<int>>[];
    final visited = List.generate(rows, (_) => List.generate(cols, (_) => false));
    final parent = List.generate(rows, (_) => List.generate(cols, (_) => <int>[]));

    queue.add([start!.dx.toInt(), start!.dy.toInt()]);
    visited[start!.dx.toInt()][start!.dy.toInt()] = true;

    bool found = false;
    while (queue.isNotEmpty && !found) {
      final current = queue.removeAt(0);
      final r = current[0], c = current[1];
      for (final d in [
        [0, 1],
        [1, 0],
        [0, -1],
        [-1, 0]
      ]) {
        final nr = r + d[0], nc = c + d[1];
        if (nr >= 0 &&
            nr < rows &&
            nc >= 0 &&
            nc < cols &&
            !visited[nr][nc] &&
            (grid[nr][nc] == CellType.empty || grid[nr][nc] == CellType.end)) {
          queue.add([nr, nc]);
          visited[nr][nc] = true;
          parent[nr][nc] = [r, c];
          if (grid[nr][nc] == CellType.end) {
            found = true;
            break;
          }
        }
      }
    }

    // Remonte le chemin si trouvé
    if (found) {
      int r = end!.dx.toInt(), c = end!.dy.toInt();
      while (parent[r][c].isNotEmpty) {
        final pr = parent[r][c][0], pc = parent[r][c][1];
        if (grid[r][c] != CellType.end) {
          grid[r][c] = CellType.path;
        }
        r = pr;
        c = pc;
        if (grid[r][c] == CellType.start) break;
      }
      setState(() {});
    }
  }

  Widget _buildCell(int row, int col) {
    Color color;
    Widget? child;
    switch (grid[row][col]) {
      case CellType.wall:
        color = Colors.black;
        break;
      case CellType.start:
        color = Colors.green;
        child = const Icon(Icons.play_arrow, color: Colors.white, size: 18);
        break;
      case CellType.end:
        color = Colors.red;
        child = const Icon(Icons.flag, color: Colors.white, size: 18);
        break;
      case CellType.path:
        color = Colors.blueAccent;
        break;
      case CellType.empty:
      default:
        color = Colors.white;
    }
    return GestureDetector(
      onTap: () => _onCellTap(row, col),
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Center(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Labyrinthe'),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.route),
            tooltip: 'Résoudre',
            onPressed: _solveMaze,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          ToggleButtons(
            isSelected: [
              selectedType == CellType.wall,
              selectedType == CellType.start,
              selectedType == CellType.end,
            ],
            onPressed: (index) {
              setState(() {
                selectedType = CellType.values[index + 1];
              });
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.stop, color: Colors.black),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.play_arrow, color: Colors.green),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.flag, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: AspectRatio(
              aspectRatio: cols / rows,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                ),
                itemCount: rows * cols,
                itemBuilder: (context, index) {
                  final row = index ~/ cols;
                  final col = index % cols;
                  return _buildCell(row, col);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}