import '../../home/models/chalet.dart';

/// A single page of the /api/Chalets paginated response.
class ChaletsPage {
  const ChaletsPage({
    required this.chalets,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasMore,
  });

  final List<Chalet> chalets;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasMore;
}
