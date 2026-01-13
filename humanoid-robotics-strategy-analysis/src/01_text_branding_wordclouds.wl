(*01 — Text Branding Analysis (Top Words + Word Clouds)

What this file does:
- Computes the top 25 word counts for Tesla and Agility text.
- Generates word clouds from the top 20 most frequent non-stopwords.

Why this matters:
Word choice reflects positioning. These outputs show whether language emphasizes futuristic AI narratives
versus near-term operational deployment.
*)

teslaTopWords = getTopWordCounts[teslaText, 25];
agilityTopWords = getTopWordCounts[agilityText, 25];

teslaTopWords
agilityTopWords

cleanWords = DeleteStopwords[TextWords[ToLowerCase[teslaText]]];
wordCounts = Tally[cleanWords];
sorted = Reverse@SortBy[wordCounts, Last];
top20 = sorted[[ ;; Min[20, Length[sorted]]]];
WordCloud[top20]

cleanWords = DeleteStopwords[TextWords[ToLowerCase[agilityText]]];
wordCounts = Tally[cleanWords];
sorted = Reverse@SortBy[wordCounts, Last];
top20 = sorted[[ ;; Min[20, Length[sorted]]]];
WordCloud[top20]

