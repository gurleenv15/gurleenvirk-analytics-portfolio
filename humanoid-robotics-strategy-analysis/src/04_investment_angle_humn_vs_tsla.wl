(*
=====================================================
FILE: 04_investment_angle_humn_vs_tsla.wl

PURPOSE:
Translate the robotics narrative into an investment framing:
Should an investor (or strategy team) think of humanoid robotics exposure as:
(1) a concentrated single-company bet (TSLA), or
(2) a diversified ecosystem bet (HUMN ETF)?

DATA SOURCE:
Holdings data manually captured from Roundhill HUMN ETF website:
https://www.roundhillinvestments.com/etf/humn/

OUTPUTS:
- Clean holdings dataset
- Top 10 holdings weight chart (concentration signal)
- Segment exposure pie chart (ecosystem breadth signal)
- TSLA vs benchmark cumulative returns plot (single-stock risk framing)
=====================================================

*)

(* =========================
   1) DEFINE RAW DATA (AS CAPTURED FROM WEBSITE)
   ========================= *)

humnHoldings = {
  {"Ticker", "Name", "Identifier", "Weight", "Shares", "Market Value"},
  {"005380 KS", "Hyundai Motor Co", "6451055", "2.82%", "5,061", "$899,909"},
  {"1810 HK", "Xiaomi Corp", "BG0ZMJ9", "2.55%", "154,400", "$813,487"},
  {"2049 TT", "Hiwin Technologies Corp", "B1YMYT5", "1.75%", "90,868", "$558,786"},
  {"2432 HK", "Shenzhen Dobot Corp Ltd", "BTDQ4G1", "4.59%", "284,600", "$1,465,110"},
  {"2498 HK", "RoboSense Technology Co Ltd", "BNG5JM4", "1.92%", "145,900", "$613,913"},
  {"277810 KS", "Rainbow Robotics", "BM9Q3J2", "4.88%", "5,269", "$1,558,504"},
  {"454910 KS", "Doosan Robotics Inc", "BN4P528", "2.79%", "16,891", "$890,118"},
  {"6268 JP", "Nabtesco Corp", "6687571", "2.59%", "38,000", "$828,183"},
  {"6324 JP", "Harmonic Drive Systems Inc", "6108179", "3.63%", "58,500", "$1,158,378"},
  {"6481 JP", "THK Co Ltd", "6869131", "0.85%", "10,600", "$271,639"},
  {"6506 JP", "Yaskawa Electric Corp", "6986041", "1.79%", "22,100", "$572,008"},
  {"6861 JP", "Keyence Corp", "6490995", "1.60%", "1,500", "$510,797"},
  {"688017 C1", "Leader Harmonious Drive Systems Co Ltd", "BMGJQ17", "3.36%", "51,704", "$1,073,117"},
  {"688256 C1", "Cambricon Technologies Corp Ltd", "BNHPMD5", "0.74%", "1,256", "$236,145"},
  {"6954 JP", "FANUC Corp", "6356934", "1.83%", "18,100", "$582,958"},
  {"7012 JP", "Kawasaki Heavy Industries Ltd", "6484620", "1.69%", "8,500", "$538,269"},
  {"9880 HK", "UBTech Robotics Corp Ltd", "BR4VSK3", "9.53%", "209,600", "$3,042,129"},
  {"ABB SS", "ABB Ltd", "7113815", "2.87%", "12,667", "$915,131"},
  {"AMD", "Advanced Micro Devices Inc", "007903107", "1.74%", "2,558", "$556,441"},
  {"AMZN", "Amazon.com Inc", "023135106", "2.83%", "3,877", "$904,193"},
  {"CNY", "CHINESE YUAN", "CASHCNY", "0.00%", "4,902", "$692"},
  {"GOOGL", "Alphabet Inc", "02079K305", "2.23%", "2,225", "$712,400"},
  {"HEXAB SS", "Hexagon AB", "BNZFHC1", "2.90%", "79,049", "$925,280"},
  {"HSAI", "Hesai Group", "428050108", "1.75%", "29,090", "$559,400"},
  {"MBLY", "Mobileye Global Inc", "60741F104", "1.71%", "46,274", "$546,958"},
  {"META", "Meta Platforms Inc", "30303M102", "1.08%", "532", "$344,709"},
  {"NVDA", "NVIDIA Corp", "67066G104", "4.48%", "8,072", "$1,428,744"},
  {"OUST", "Ouster Inc", "68989M202", "1.70%", "23,654", "$543,095"},
  {"QCOM", "QUALCOMM Inc", "747525103", "2.63%", "4,986", "$838,096"},
  {"RBC", "RBC Bearings Inc", "75524B104", "0.84%", "601", "$267,426"},
  {"ROK", "Rockwell Automation Inc", "773903109", "0.84%", "676", "$267,601"},
  {"SHA0 GR", "Schaeffler AG", "BV5F6V9", "2.14%", "88,583", "$684,681"},
  {"SKFB SS", "SKF AB", "B1Q3J35", "0.85%", "10,324", "$270,366"},
  {"TER", "Teradyne Inc", "880770102", "3.37%", "5,919", "$1,076,606"},
  {"TKR", "Timken Co/The", "887389104", "0.83%", "3,272", "$266,308"},
  {"TSLA", "Tesla Inc", "88160R101", "9.78%", "7,257", "$3,121,743"},
  {"XPEV", "XPeng Inc", "98422D105", "6.14%", "89,767", "$1,959,613"},
  {"Cash&Other", Missing["NotAvailable"], "Cash&Other", "0.34%", Missing["NotAvailable"], "$108,030"}
};

(* =========================
   2) SEPARATE HEADER AND DATA ROWS
   ========================= *)

header = humnHoldings[[1]];
dataRows = humnHoldings[[2 ;;]];

(* =========================
   3) CLEANING FUNCTIONS
   Tech: normalize strings into usable numeric types
   Business: enables accurate weight/market value comparisons
   ========================= *)

cleanWeight[weight_String] := ToExpression@StringDelete[weight, "%"]/100;
cleanWeight[val_] := val; (* Handles Missing/non-string *)

cleanShares[shares_String] := ToExpression@StringDelete[shares, ","];
cleanShares[val_] := val;

cleanMarketValue[value_String] := ToExpression@StringDelete[value, {"$", ",", " "}];
cleanMarketValue[val_] := val;

(* =========================
   4) APPLY CLEANING TO DATA
   ========================= *)

cleanedData =
  Map[
    {
      #[[1]],                      (* Ticker *)
      #[[2]],                      (* Name *)
      #[[3]],                      (* Identifier *)
      cleanWeight[#[[4]]],         (* Weight *)
      cleanShares[#[[5]]],         (* Shares *)
      cleanMarketValue[#[[6]]]     (* Market Value *)
    } &,
    dataRows
  ];

(* =========================
   5) CONVERT TO ASSOCIATIONS + DATASET
   Business: makes the holdings easy to query (e.g., top weights)
   ========================= *)

associations = AssociationThread[header, #] & /@ cleanedData;
holdingsDataset = Dataset[associations];

(* =========================
   6) VISUALIZATION: TOP 10 HOLDINGS (CONCENTRATION SIGNAL)
   Business meaning: reveals concentration risk / “how diversified is HUMN?”
   ========================= *)

top10Holdings = SortBy[holdingsDataset, #Weight &, Greater][1 ;; 10];

top10WeightChart =
  BarChart[
    top10Holdings[All, "Weight"] // Normal,
    ChartLabels -> (Rotate[#, Pi/2] & /@ top10Holdings[All, "Name"] // Normal),
    AxesLabel -> {"Company", "Portfolio Weight"},
    PlotLabel -> "Top 10 HUMN ETF Holdings by Weight",
    ImageSize -> Large,
    ChartStyle -> "DarkBands",
    LabelingFunction -> (Placed[ToString[NumberForm[#*100, {4, 2}]] <> "%", Above] &)
  ];

(* Display Dataset and Chart together *)
{holdingsDataset, top10WeightChart};

(* =========================
   7) SEGMENT EXPOSURE (ECOSYSTEM BREADTH SIGNAL)
   ========================= *)

segmentHolding[ticker_String] :=
  Which[
    MemberQ[{"TSLA","005380 KS","XPEV"}, ticker], "OEM / Robotics Platform",
    MemberQ[{"NVDA","AMD","QCOM","GOOGL","META","AMZN"}, ticker], "AI / Compute",
    MemberQ[{"FANUC","Yaskawa Electric Corp","6954 JP","6506 JP","6324 JP","6481 JP","6268 JP","7012 JP","ABB SS","ROK","TER"}, ticker], "Industrial Automation",
    True, "Robotics & Components"
  ];

(* Build cleaned dataset with segment labels and clean weights *)
holdingsDatasetCleaned =
  Map[AssociationThread[header, #] &, dataRows] //
    Map[
      <|
        "Ticker" -> #Ticker,
        "Segment" -> segmentHolding[#Ticker],
        "Weight" -> cleanWeight[#Weight]
      |> &
    ] // Dataset;

(* Summarize weights by segment *)
segmentSummary =
  Normal @ Merge[
    holdingsDatasetCleaned[All, #Segment -> #Weight &],
    Total
  ];

segments = Keys[segmentSummary];
weights = Values[segmentSummary];

labels =
  MapThread[
    Row[{#1, " (", NumberForm[100 #2, {3, 1}], "%)"}] &,
    {segments, weights}
  ];

segmentPieChart =
  PieChart[
    weights,
    ChartLabels -> labels,
    PlotLabel -> "HUMN ETF Exposure by Robotics Ecosystem Segment",
    ImageSize -> Large,
    ChartStyle -> ColorData["BrightBands", "ColorList"],
    SectorSpacing -> 0.01
  ];

segmentPieChart;

(* =========================
   8) SINGLE-STOCK RISK: TSLA vs NASDAQ TECH BENCHMARK
   Business meaning: illustrates volatility / concentration risk of a single bet
   ========================= *)

start = {2022, 1, 1};
end = Today;

tsla = FinancialData["TSLA", "CumulativeFractionalChange", {start, end}];
nasdaq = FinancialData["^IXIC", "CumulativeFractionalChange", {start, end}];

DateListPlot[
  {tsla, nasdaq},
  Frame -> True,
  PlotRange -> All,
  PlotLegends -> {"Tesla", "NASDAQ Tech Benchmark"},
  FrameLabel -> {"Date", "Cumulative Return"},
  PlotLabel -> "Single-Stock Risk (TSLA) vs Diversified Tech Exposure (NASDAQ)"
];

(*
EXECUTIVE TAKEAWAY (what to say in an interview):
- HUMN quantifies diversified ecosystem exposure (components + automation + AI compute).
- TSLA offers concentrated upside but higher single-stock variance.
- This framing translates “robotics narrative” into a practical risk-managed investment lens.
*)

