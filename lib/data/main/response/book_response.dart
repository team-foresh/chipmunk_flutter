import 'package:chipmunk_flutter/domain/main/entity/book_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class BookResponse extends BookEntity {
  @JsonKey(name: 'documents')
  final List<Document>? documents_;
  @JsonKey(name: 'meta')
  final Meta? meta_;

  BookResponse({
    this.documents_,
    this.meta_,
  }) : super(
          documents: documents_
                  ?.map(
                    (e) => DocumentEntity(
                      title: e.title,
                      contents: e.contents,
                      thumbnail: e.thumbnail,
                    ),
                  )
                  .toList() ??
              List.empty(),
        );

  factory BookResponse.fromJson(Map<String, dynamic> json) => _$BookResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookResponseToJson(this);
}

@JsonSerializable(ignoreUnannotated: false)
class Document {
  @JsonKey(name: 'authors')
  final List<String>? authors;
  @JsonKey(name: 'contents')
  final String? contents;
  @JsonKey(name: 'datetime')
  final String? datetime;
  @JsonKey(name: 'isbn')
  final String? isbn;
  @JsonKey(name: 'price')
  final int? price;
  @JsonKey(name: 'publisher')
  final String? publisher;
  @JsonKey(name: 'sale_price')
  final int? salePrice;
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'thumbnail')
  final String? thumbnail;
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'translators')
  final List<String>? translators;
  @JsonKey(name: 'url')
  final String? url;

  Document(
      {this.authors,
      this.contents,
      this.datetime,
      this.isbn,
      this.price,
      this.publisher,
      this.salePrice,
      this.status,
      this.thumbnail,
      this.title,
      this.translators,
      this.url});

  factory Document.fromJson(Map<String, dynamic> json) => _$DocumentFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentToJson(this);
}

@JsonSerializable(ignoreUnannotated: false)
class Meta {
  @JsonKey(name: 'is_end')
  final bool? isEnd;
  @JsonKey(name: 'pageable_count')
  final int? pageableCount;
  @JsonKey(name: 'total_count')
  final int? totalCount;

  Meta({
    this.isEnd,
    this.pageableCount,
    this.totalCount,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
