import axios from "axios";

const RSS_SOURCES = [
  "https://vietstock.vn/rss/tai-chinh-doanh-nghiep.rss",
  "https://vietstock.vn/rss/chung-khoan.rss",
];

interface NewsItem {
  title: string;
  description: string;
  pubDate: string;
}

function parseRssItems(xml: string): NewsItem[] {
  const items: NewsItem[] = [];
  const itemRegex = /<item>([\s\S]*?)<\/item>/g;
  let match;

  while ((match = itemRegex.exec(xml)) !== null) {
    const item = match[1];
    const title = item.match(/<title><!\[CDATA\[(.*?)\]\]><\/title>/)?.[1] ??
      item.match(/<title>(.*?)<\/title>/)?.[1] ?? "";
    const description = item.match(/<description><!\[CDATA\[(.*?)\]\]><\/description>/)?.[1] ??
      item.match(/<description>(.*?)<\/description>/)?.[1] ?? "";
    const pubDate = item.match(/<pubDate>(.*?)<\/pubDate>/)?.[1] ?? "";

    if (title) items.push({ title, description: description.replace(/<[^>]+>/g, ""), pubDate });
  }

  return items;
}

export async function fetchMarketNews(): Promise<string> {
  const allItems: NewsItem[] = [];

  for (const url of RSS_SOURCES) {
    try {
      const res = await axios.get<string>(url, {
        timeout: 5000,
        headers: { "User-Agent": "FTrade/1.0" },
      });
      allItems.push(...parseRssItems(res.data).slice(0, 10));
    } catch (err) {
      console.warn(`Failed to fetch RSS: ${url}`, err instanceof Error ? err.message : err);
    }
  }

  if (allItems.length === 0) {
    return "Không lấy được tin tức hôm nay. Hãy phân tích dựa trên xu hướng chung.";
  }

  const unique = allItems
    .filter((item, idx, arr) => arr.findIndex((i) => i.title === item.title) === idx)
    .slice(0, 15);

  return unique
    .map((item, i) => `${i + 1}. ${item.title}\n${item.description.slice(0, 200)}`)
    .join("\n\n");
}
