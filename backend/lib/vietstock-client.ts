import axios, { AxiosInstance } from "axios";

const BASE = "https://finance.vietstock.vn";
const EVENTS_PAGE = `${BASE}/lich-su-kien.htm`;
const EVENT_TYPES_URL = `${BASE}/data/eventtypebyid`;
const EVENT_DATA_URL = `${BASE}/data/eventstypedata`;

const TOKEN_REGEX = /name=__RequestVerificationToken type=hidden value=([^ >]+)/;

interface TokenEntry {
  token: string;
  cookie: string;
  fetchedAt: number;
}

let _tokenCache: TokenEntry | null = null;

const http: AxiosInstance = axios.create({
  timeout: 15_000,
  headers: { "User-Agent": "Mozilla/5.0" },
});

async function getToken(): Promise<TokenEntry> {
  const now = Date.now();
  if (_tokenCache && now - _tokenCache.fetchedAt < 10 * 60 * 1000) {
    return _tokenCache;
  }

  const res = await http.get<string>(EVENTS_PAGE, {
    responseType: "text",
    headers: { "User-Agent": "Mozilla/5.0" },
  });

  const match = TOKEN_REGEX.exec(res.data);
  if (!match) throw new Error("Cannot extract Vietstock CSRF token");

  const setCookies: string[] = (res.headers["set-cookie"] as string[] | undefined) ?? [];
  const cookie = setCookies
    .map((c) => c.split(";")[0].trim())
    .filter(Boolean)
    .join("; ");

  _tokenCache = { token: match[1], cookie, fetchedAt: now };
  return _tokenCache;
}

async function postForm(url: string, data: Record<string, string>): Promise<unknown> {
  const { token, cookie } = await getToken();
  const body = new URLSearchParams({ ...data, __RequestVerificationToken: token });
  const res = await http.post(url, body.toString(), {
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      Origin: BASE,
      Referer: EVENTS_PAGE,
      "X-Requested-With": "XMLHttpRequest",
      Cookie: cookie,
    },
  });
  return res.data;
}

// ── Channel IDs ──────────────────────────────────────────────────────────────

const CHANNEL_CASH_DIV = 13;
const CHANNEL_BONUS = 14;
const CHANNEL_STOCK_DIV = 15;
const CHANNEL_RIGHTS = 16;
const CHANNELS_AGM = [34, 35, 36];

let _channelCache: Map<number, number[]> = new Map();

async function getChannels(eventTypeId: number): Promise<number[]> {
  if (_channelCache.has(eventTypeId)) return _channelCache.get(eventTypeId)!;

  const payload = (await postForm(EVENT_TYPES_URL, {
    id: String(eventTypeId),
    languageID: "1",
    page: "1",
    pageSize: "50",
    orderBy: "Name",
    orderDir: "asc",
  })) as unknown[][];

  const channels =
    Array.isArray(payload) && payload.length > 1
      ? (payload[1] as Record<string, unknown>[])
          .map((item) => Number(item["ChannelID"] ?? 0))
          .filter((id) => id > 0)
      : [];

  _channelCache.set(eventTypeId, channels);
  return channels;
}

// ── Event rows ───────────────────────────────────────────────────────────────

function fmt(date: Date): string {
  return date.toISOString().slice(0, 10);
}

async function fetchEventRows(
  eventTypeId: number,
  channelId: number,
  fromDate: Date,
  toDate: Date,
  orderBy: string
): Promise<Record<string, unknown>[]> {
  const payload = (await postForm(EVENT_DATA_URL, {
    eventTypeID: String(eventTypeId),
    channelID: String(channelId),
    code: "",
    fDate: fmt(fromDate),
    tDate: fmt(toDate),
    page: "1",
    pageSize: "200",
    orderBy,
    orderDir: "asc",
    showEvent: "True",
    showColor: "False",
    showPopup: "False",
    showLatestNews: "False",
  })) as unknown[];

  const rows = Array.isArray(payload) && Array.isArray(payload[0]) ? payload[0] : payload;
  return (rows as Record<string, unknown>[]).map((r) => ({
    ...r,
    __channelId: channelId,
    __eventTypeId: eventTypeId,
  }));
}

// ── Public API ───────────────────────────────────────────────────────────────

export interface UpcomingEvent {
  symbol: string;
  type: "dividend" | "rights" | "agm" | "other";
  title: string;
  eventDate: Date;
  cashAmount?: number; // VND per share
  shareRatio?: number; // percentage
}

function parseDate(value: unknown): Date | null {
  if (!value) return null;
  const s = String(value);
  const match = /\/Date\((\d+)\)\//.exec(s);
  if (match) return new Date(Number(match[1]));
  const d = new Date(s);
  return isNaN(d.getTime()) ? null : d;
}

function clean(value: unknown): string {
  return String(value ?? "")
    .replace(/<[^>]+>/g, " ")
    .replace(/&nbsp;/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function rowToEvent(row: Record<string, unknown>): UpcomingEvent | null {
  const symbol = String(row["Code"] ?? "").toUpperCase();
  if (!symbol) return null;

  const channelId = Number(row["__channelId"] ?? 0);
  const isDiv = [CHANNEL_CASH_DIV, CHANNEL_BONUS, CHANNEL_STOCK_DIV].includes(channelId);
  const isRights = channelId === CHANNEL_RIGHTS;
  const isAgm = CHANNELS_AGM.includes(channelId);

  const type = isDiv ? "dividend" : isRights ? "rights" : isAgm ? "agm" : "other";

  const eventDate =
    parseDate(row["GDKHQDate"]) ??
    parseDate(row["Time"]) ??
    parseDate(row["DateOrder"]);
  if (!eventDate) return null;

  const title = clean(row["Note"]) || clean(row["Title"]);

  // Parse cash dividend amount from note text like "500 đồng/CP"
  let cashAmount: number | undefined;
  if (isDiv && channelId === CHANNEL_CASH_DIV) {
    const noteText = `${clean(row["Note"])} ${clean(row["Title"])}`;
    const m = /([\d.,]+)\s*đồng\s*\/\s*CP/i.exec(noteText);
    cashAmount = m ? parseFloat(m[1].replace(/\./g, "").replace(",", ".")) : undefined;
  }

  return { symbol, type, title, eventDate, cashAmount };
}

/** Fetch all upcoming corporate events (dividend, rights, AGM) within [now, +daysAhead] */
export async function fetchUpcomingEvents(daysAhead = 3): Promise<UpcomingEvent[]> {
  const now = new Date();
  const to = new Date(now.getTime() + daysAhead * 86_400_000);

  const [divChannels, agmChannels] = await Promise.all([
    getChannels(1),
    getChannels(5),
  ]);

  const useDivChannels = divChannels.length
    ? divChannels.filter((id) => [CHANNEL_CASH_DIV, CHANNEL_BONUS, CHANNEL_STOCK_DIV, CHANNEL_RIGHTS].includes(id))
    : [CHANNEL_CASH_DIV, CHANNEL_BONUS, CHANNEL_STOCK_DIV, CHANNEL_RIGHTS];

  const useAgmChannels = agmChannels.length ? agmChannels : CHANNELS_AGM;

  const [divRows, agmRows] = await Promise.all([
    Promise.all(useDivChannels.map((ch) => fetchEventRows(1, ch, now, to, "GDKHQDate"))),
    Promise.all(useAgmChannels.map((ch) => fetchEventRows(5, ch, now, to, "Time"))),
  ]);

  const allRows = [...divRows.flat(), ...agmRows.flat()];
  const seen = new Set<string>();
  const events: UpcomingEvent[] = [];

  for (const row of allRows) {
    const ev = rowToEvent(row);
    if (!ev) continue;
    const key = `${ev.symbol}_${ev.type}_${ev.eventDate.toISOString().slice(0, 10)}`;
    if (seen.has(key)) continue;
    seen.add(key);
    events.push(ev);
  }

  return events;
}
