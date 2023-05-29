class BookEntity {
  final List<DocumentEntity> documents;

  BookEntity({
    required this.documents,
  });
}

class DocumentEntity {
  final String? contents;
  final String? thumbnail;
  final String? title;

  DocumentEntity({
    this.contents,
    this.thumbnail,
    this.title,
  });
}
