import '../../domain/entities/news_article.dart';

class NewsMockDatasource {
  Future<List<NewsArticle>> getLatestNews({int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      NewsArticle(
        id: '1',
        title: 'VN-Index vượt mốc 1.280 điểm, nhóm cổ phiếu công nghệ dẫn dắt',
        source: 'VnEconomy',
        publishedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        summary:
            'Thị trường chứng khoán Việt Nam phiên sáng giao dịch tích cực với VN-Index tăng gần 13 điểm, thanh khoản cải thiện rõ rệt.',
        relatedSymbols: ['FPT', 'CMG', 'ELC'],
      ),
      NewsArticle(
        id: '2',
        title: 'Hòa Phát (HPG) báo lãi quý 4 tăng 85% so với cùng kỳ',
        source: 'CafeF',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        summary:
            'CTCP Tập đoàn Hòa Phát ghi nhận doanh thu thuần 35.200 tỷ đồng, lợi nhuận sau thuế đạt 4.100 tỷ đồng trong quý 4.',
        relatedSymbols: ['HPG'],
      ),
      NewsArticle(
        id: '3',
        title: 'Khối ngoại mua ròng hơn 500 tỷ đồng phiên hôm nay',
        source: 'VietStock',
        publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
        summary:
            'Nhà đầu tư nước ngoài đẩy mạnh mua ròng trên sàn HOSE, tập trung vào nhóm ngân hàng và bất động sản.',
        relatedSymbols: ['VCB', 'BID', 'VHM'],
      ),
      NewsArticle(
        id: '4',
        title: 'FPT ký hợp đồng AI trị giá 200 triệu USD với đối tác Nhật Bản',
        source: 'VnExpress',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        summary:
            'FPT Software vừa ký kết thỏa thuận hợp tác chiến lược về AI và chuyển đổi số với tập đoàn NTT Data.',
        relatedSymbols: ['FPT'],
      ),
      NewsArticle(
        id: '5',
        title: 'NHNN giữ nguyên lãi suất điều hành, hỗ trợ tăng trưởng kinh tế',
        source: 'TBKTSG',
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        summary:
            'Ngân hàng Nhà nước quyết định giữ nguyên các mức lãi suất điều hành nhằm ổn định vĩ mô và hỗ trợ doanh nghiệp.',
      ),
      NewsArticle(
        id: '6',
        title: 'Vingroup (VIC) công bố kế hoạch mở rộng VinFast tại Đông Nam Á',
        source: 'Bloomberg Vietnam',
        publishedAt: DateTime.now().subtract(const Duration(hours: 10)),
        summary:
            'Vingroup dự kiến đầu tư thêm 2 tỷ USD để xây dựng nhà máy VinFast tại Indonesia và Philippines.',
        relatedSymbols: ['VIC'],
      ),
      NewsArticle(
        id: '7',
        title: 'Thị trường bất động sản TP.HCM phục hồi mạnh quý đầu năm',
        source: 'VnEconomy',
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        summary:
            'Giao dịch BĐS tại TP.HCM tăng 40% so với cùng kỳ, phân khúc căn hộ trung cấp dẫn đầu thanh khoản.',
        relatedSymbols: ['VHM', 'NVL', 'KDH'],
      ),
    ];
  }

  Future<List<NewsArticle>> getNewsBySymbol(String symbol) async {
    final all = await getLatestNews();
    return all
        .where(
          (n) => n.relatedSymbols?.contains(symbol) ?? false,
        )
        .toList();
  }

  Future<NewsArticle> getNewsDetail(String id) async {
    final all = await getLatestNews();
    return all.firstWhere((n) => n.id == id);
  }
}
