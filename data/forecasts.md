# Forecast Ledger

Source of truth for the Forecasts table in index.html.
To add a new forecast: copy the row template, increment #, prepend it as the first <tr> in the tbody.
To resolve: change result-open to result-hit / result-miss / result-partial and update the text.

Scoring rule: HIT / MISS / PARTIAL decided on or after the resolution date.
Misses stay visible — never delete.

---

## Template row

```html
<tr>
  <td class="forecast-num">#N</td>
  <td class="forecast-date">YYYY-MM-DD</td>
  <td class="forecast-text">Forecast statement here.</td>
  <td class="forecast-resolve">YYYY-MM-DD</td>
  <td class="forecast-result result-open">OPEN</td>
</tr>
```

Result classes: result-open (gold) | result-hit (green) | result-miss (red) | result-partial (orange)

---

## Current forecasts

| # | Made       | Resolves   | Result |
|---|------------|------------|--------|
| 2 | 2026-06-30 | 2026-12-31 | OPEN   |
| 1 | 2026-06-29 | 2026-12-31 | OPEN   |
