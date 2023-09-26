class Homework {
  int id;
  String lesson;
  String course;
  String group;
  String title;
  String description;
  DateTime dateTime;
  DateTime creationDate;
  bool isCompleted;

  Homework({
    required this.id,
    required this.lesson,
    required this.course,
    required this.title,
    required this.description,
    required this.group,
    required this.dateTime,
    required this.creationDate,
    this.isCompleted = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Homework &&
          runtimeType == other.runtimeType &&
          lesson == other.lesson &&
          description == other.description &&
          dateTime == other.dateTime &&
          creationDate == other.creationDate);

  @override
  int get hashCode =>
      lesson.hashCode ^
      description.hashCode ^
      dateTime.hashCode ^
      creationDate.hashCode;

  @override
  String toString() {
    return 'Homework{ lesson: $lesson, description: $description, dateTime: $dateTime, creationDate: $creationDate,}';
  }

  Homework copyWith({
    int? id,
    String? lesson,
    String? course,
    String? description,
    String? group,
    String? title,
    DateTime? dateTime,
    DateTime? creationDate,
    bool? isCompleted,
  }) {
    return Homework(
      id: id ?? this.id,
      lesson: lesson ?? this.lesson,
      title: title ?? this.title,
      description: description ?? this.description,
      group: group ?? this.group,
      course: course ?? this.course,
      dateTime: dateTime ?? this.dateTime,
      creationDate: creationDate ?? this.creationDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lesson': lesson,
      'title': title,
      'description': description,
      'course': course,
      'group': group,
      'confirm_by': dateTime.millisecondsSinceEpoch,
      'created_at': creationDate.millisecondsSinceEpoch,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory Homework.fromMap(Map<String, dynamic> map) {
    print(DateTime.now().millisecondsSinceEpoch);
    return Homework(
        id: map['id'] as int,
        lesson: map['lesson'] as String,
        course: map['course'] as String,
        group: map['group'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        dateTime: DateTime.fromMillisecondsSinceEpoch(map['confirm_by']),
        creationDate: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
        isCompleted: map['is_completed'] == 1);
  }
}
