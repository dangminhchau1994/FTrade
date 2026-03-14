import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/format_utils.dart';
import '../../data/datasources/news_mock_datasource.dart';
import '../../domain/entities/news_article.dart';

final newsDetailProvider =
    FutureProvider.family<NewsArticle, String>((ref, id) {
  return NewsMockDatasource().getNewsDetail(id);
});

class NewsDetailScreen extends ConsumerWidget {
  final String id;

  const NewsDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final article = ref.watch(newsDetailProvider(id));

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: article.when(
        data: (a) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                a.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      a.source,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    FormatUtils.timeAgo(a.publishedAt),
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
              if (a.relatedSymbols != null &&
                  a.relatedSymbols!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: a.relatedSymbols!
                      .map(
                        (symbol) => ActionChip(
                          label: Text(symbol),
                          onPressed: () => context.push('/stock/$symbol'),
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              if (a.summary != null)
                Text(
                  a.summary!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ),
              const SizedBox(height: 16),
              // Mock full content
              Text(
                _mockContent(a.title),
                style: TextStyle(
                  fontSize: 15,
                  height: 1.7,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
      ),
    );
  }

  String _mockContent(String title) {
    return 'Theo các chuyên gia phân tích, diễn biến thị trường trong phiên giao dịch '
        'hôm nay cho thấy nhiều tín hiệu tích cực. Dòng tiền đang có xu hướng quay trở lại '
        'các nhóm cổ phiếu trụ, đặc biệt là nhóm ngân hàng và công nghệ.\n\n'
        'Thanh khoản thị trường cải thiện đáng kể so với phiên trước, cho thấy sự tham gia '
        'tích cực hơn của nhà đầu tư. Khối ngoại cũng ghi nhận phiên mua ròng đáng kể '
        'tập trung vào các mã vốn hóa lớn.\n\n'
        'Về mặt kỹ thuật, VN-Index đang tiếp cận vùng kháng cự quan trọng. Nếu vượt qua '
        'được vùng này với thanh khoản tốt, chỉ số có thể tiếp tục xu hướng tăng trong '
        'các phiên tới.\n\n'
        'Các chuyên gia khuyến nghị nhà đầu tư nên duy trì tỷ trọng cổ phiếu ở mức hợp lý, '
        'ưu tiên các mã có nền tảng cơ bản tốt và câu chuyện tăng trưởng rõ ràng.';
  }
}
