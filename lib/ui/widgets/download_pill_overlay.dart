import 'dart:ui';
import 'package:flutter/material.dart';
import '../../services/download_manager.dart';

class DownloadOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => const Positioned(
        // NUEVO: Se redujo de 20 a 4 para pegarlo más al borde superior.
        // La SafeArea evitará que se solape con la barra de estado (batería, reloj).
        top: 4, 
        left: 0,
        right: 0,
        child: SafeArea(
          child: DownloadPillWidget(),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
}

class DownloadPillWidget extends StatefulWidget {
  const DownloadPillWidget({super.key});

  @override
  State<DownloadPillWidget> createState() => _DownloadPillWidgetState();
}

class _DownloadPillWidgetState extends State<DownloadPillWidget> {
  bool _isExpanded = false;
  // NUEVO: Variable para rastrear la cantidad de descargas en el frame anterior
  int _previousTaskCount = 0; 

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: DownloadManager.instance,
      builder: (context, _) {
        final tasks = DownloadManager.instance.activeDownloads;
        final currentTaskCount = tasks.length;
        
        // NUEVO: Si la cantidad actual es mayor a la anterior, inició una nueva descarga.
        if (currentTaskCount > _previousTaskCount) {
          _isExpanded = true;
        } 
        // Si se vacía la lista, la contraemos internamente para que la próxima vez 
        // que inicie una descarga, la animación comience desde el estado colapsado.
        else if (currentTaskCount == 0) {
          _isExpanded = false;
        }
        
        // Actualizamos el contador para la siguiente evaluación
        _previousTaskCount = currentTaskCount;

        final totalProgress = tasks.isEmpty 
            ? 0.0 
            : tasks.fold(0.0, (sum, task) => sum + task.progress) / tasks.length;
            
        final downloadingTasks = tasks.where((t) => t.status == DownloadStatus.downloading).length;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeInBack,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
          child: tasks.isEmpty
              ? const SizedBox.shrink(key: ValueKey('empty_pill'))
              : Center(
                  key: const ValueKey('active_pill'),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_isExpanded ? 24 : 32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_isExpanded ? 24 : 32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Material(
                          color: const Color(0xFF1E1E1E).withOpacity(0.85),
                          child: InkWell(
                            onTap: () => setState(() => _isExpanded = !_isExpanded),
                            highlightColor: Colors.tealAccent.withOpacity(0.1),
                            splashColor: Colors.tealAccent.withOpacity(0.2),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.tealAccent.withOpacity(0.3), 
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(_isExpanded ? 24 : 32),
                              ),
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeOutExpo,
                                alignment: Alignment.topCenter,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: _isExpanded 
                                      ? _buildExpandedList(tasks) 
                                      : _buildCollapsedPill(downloadingTasks, totalProgress),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildCollapsedPill(int count, double progress) {
    return Container(
      key: const ValueKey('collapsed'), 
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              value: progress > 0 ? progress : null, 
              color: Colors.tealAccent, 
              backgroundColor: Colors.grey[800],
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "Descargando $count mod${count != 1 ? 's' : ''}",
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 14, 
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedList(List<DownloadTask> tasks) {
    return Container(
      key: const ValueKey('expanded'),
      width: 400,
      constraints: const BoxConstraints(maxHeight: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Descargas Activas", 
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = false),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white70, size: 16),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.white.withOpacity(0.1)),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(12),
              itemCount: tasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.fileName, 
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ), 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      if (task.status == DownloadStatus.fetching)
                        const LinearProgressIndicator(color: Colors.tealAccent)
                      else if (task.status == DownloadStatus.error)
                        Text(
                          task.errorMessage ?? "Error", 
                          style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                        )
                      else ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: task.progress, 
                            backgroundColor: Colors.white.withOpacity(0.1), 
                            color: Colors.tealAccent,
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              task.downloaded, 
                              style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                            ),
                            Text(
                              task.speed, 
                              style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      ]
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}