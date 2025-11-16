import 'package:uuid/uuid.dart';

import '../models/project.dart';
import '../models/task.dart';
import '../models/task_context.dart';
import '../models/task_status.dart';
import '../models/energy_level.dart';
import '../repositories/projects_repository.dart';
import '../repositories/tasks_repository.dart';

class DummyDataSeeder {
  DummyDataSeeder(this._tasksRepository, this._projectsRepository);

  final ITasksRepository _tasksRepository;
  final IProjectsRepository _projectsRepository;
  final _uuid = const Uuid();

  Future<void> seedIfEmpty() async {
    if (_tasksRepository.allTasks().isNotEmpty ||
        _projectsRepository.allProjects().isNotEmpty) {
      return;
    }

    final mathProject = Project(
      id: _uuid.v4(),
      name: 'Mathe-Klausur vorbereiten',
      description: 'Lernplan und Übungsblätter organisieren',
      deadline: DateTime.now().add(const Duration(days: 21)),
    );
    final paperProject = Project(
      id: _uuid.v4(),
      name: 'Hausarbeit schreiben',
      description: 'Gliederung finalisieren und Quellen sammeln',
      deadline: DateTime.now().add(const Duration(days: 35)),
    );
    final labProject = Project(
      id: _uuid.v4(),
      name: 'Laborprotokoll abgeben',
      description: 'Messwerte bereinigen und abgleichen',
      deadline: DateTime.now().add(const Duration(days: 10)),
    );

    await _projectsRepository.upsert(mathProject);
    await _projectsRepository.upsert(paperProject);
    await _projectsRepository.upsert(labProject);

    final tasks = [
      Task(
        id: _uuid.v4(),
        title: 'Kapitel über Integrale wiederholen',
        context: TaskContext.uni,
        projectId: mathProject.id,
        dueDate: DateTime.now().add(const Duration(days: 14)),
        status: TaskStatus.nextAction,
        createdAt: DateTime.now(),
        energyLevel: EnergyLevel.medium,
        durationMinutes: 45,
      ),
      Task(
        id: _uuid.v4(),
        title: 'Professorin wegen Fragestunde anschreiben',
        context: TaskContext.telefon,
        projectId: mathProject.id,
        status: TaskStatus.waitingFor,
        createdAt: DateTime.now(),
        energyLevel: EnergyLevel.low,
        durationMinutes: 10,
      ),
      Task(
        id: _uuid.v4(),
        title: 'Gliederung finalisieren',
        context: TaskContext.laptop,
        projectId: paperProject.id,
        status: TaskStatus.nextAction,
        createdAt: DateTime.now(),
        energyLevel: EnergyLevel.high,
        durationMinutes: 90,
      ),
      Task(
        id: _uuid.v4(),
        title: 'Beispielhafte Quellen in Citavi eintragen',
        context: TaskContext.bibliothek,
        projectId: paperProject.id,
        status: TaskStatus.somedayMaybe,
        createdAt: DateTime.now(),
        energyLevel: EnergyLevel.low,
        durationMinutes: 30,
      ),
      Task(
        id: _uuid.v4(),
        title: 'Messwerte plotten',
        context: TaskContext.laptop,
        projectId: labProject.id,
        status: TaskStatus.nextAction,
        createdAt: DateTime.now(),
        energyLevel: EnergyLevel.medium,
        durationMinutes: 60,
      ),
    ];

    for (final task in tasks) {
      await _tasksRepository.upsertTask(task);
      if (task.projectId != null) {
        await _projectsRepository.attachTask(task.projectId!, task.id);
      }
    }
  }
}
