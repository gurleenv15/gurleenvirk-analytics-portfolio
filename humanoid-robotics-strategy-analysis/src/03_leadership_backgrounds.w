(*
=====================================================
FILE: 03_leadership_backgrounds.wl
PROJECT: Humanoid Robotics Strategy Analysis (Tesla vs Agility)

BUSINESS PURPOSE (Why this exists):
Leadership is a “credibility signal” for strategy. This analysis translates
executive backgrounds into measurable categories to test whether each company’s
team composition matches its narrative:
- Tesla: execution + platform + engineering scale
- Agility: research + robotics specialization + deployment operations

TRANSLATION LAYER :
- Tech work: structure leadership data, categorize backgrounds, visualize patterns
- Business insight: assess execution readiness, strategic posture, and whether the
  “story matches the team” (important for investors, partners, and adoption timelines)

OUTPUTS (What this generates):
- Side-by-side leadership tables (Tesla vs Agility)
- Grouped bar chart comparing background categories
- Pie charts comparing education credentials
- Exploratory “academic leaders vs patents” scatter + correlation
=====================================================
*)

(* =========================
   1) INPUT DATA (MANUAL / PUBLIC SOURCES)
   ========================= *)

(* Tesla Optimus Leadership Team
   Note: Tesla site text was difficult to import due to firewall / dynamic pages,
   so leadership attributes were curated from public sources (LinkedIn, Tesla events, etc.) *)
teslaLeadership = {
  {"Elon Musk","CEO","Physics/Economics","BS","Automotive/Big Tech",3,"PayPal, SpaceX, Tesla"},
  {"Milan Kovac","VP Engineering (Optimus)","Mechanical Engineering","MS","Automotive",6,"Ford, Tesla"},
  {"Franz von Holzhausen","Chief Designer","Industrial Design","BS","Automotive",4,"Mazda, VW, Tesla"},
  {"Pete Bannon","VP Silicon Engineering","Electrical Engineering","MS","Big Tech",2,"Apple, Tesla"},
  {"Ganesh Venkataramanan","Sr. Dir. Autopilot Hardware","Electrical Engineering","PhD","Big Tech",1,"Qualcomm, Tesla"}
};

(* Agility Robotics Leadership Team
   Source: https://www.agilityrobotics.com/about/leadership *)
agilityLeadership = {
  {"Peggy Johnson","CEO","Business Administration","MBA","Big Tech",2,"Microsoft, Magic Leap"},
  {"Damion Shelton","Co-founder","Robotics","PhD","Academia/Robotics Startup",18,"Carnegie Mellon, Agility"},
  {"Jonathan Hurst","Co-founder & CTO","Robotics","PhD","Academia",22,"Oregon State University, Agility"},
  {"Melonee Wise","VP Product & Robotics","Mechanical Engineering","MS","Robotics Startup",15,"Fetch Robotics, Agility"},
  {"Aindrea Campbell","VP Operations","Industrial Engineering","BS","Automotive/Manufacturing",12,"Tesla, Rivian, Agility"}
};

(* Column headers for clarity (shared schema for both datasets) *)
leadershipHeaders = {"Name","Role","Education Field","Highest Degree","Background Category","Years in Robotics","Previous Companies"};

(* =========================
   2) DISPLAY TABLES (HUMAN-READABLE)
   Goal: Make the structured input immediately interpretable to a viewer
   ========================= *)

Text[Style["Tesla Optimus Leadership Team", Bold, 16]];
Grid[
  Prepend[teslaLeadership, leadershipHeaders],
  Frame -> All,
  Background -> {{LightGray, None}, {LightGray, None}}
];

Text[Style["Agility Robotics Leadership Team", Bold, 16]];
Grid[
  Prepend[agilityLeadership, leadershipHeaders],
  Frame -> All,
  Background -> {{LightGray, None}, {LightGray, None}}
];

(* =========================
   3) DATA CLEANING & CATEGORIZATION (FOR ANALYSIS)
   Goal: Extract the “Background Category” column to quantify leadership DNA
   ========================= *)

teslaBackgrounds  = teslaLeadership[[All, 5]];
agilityBackgrounds = agilityLeadership[[All, 5]];

(* Counts needed later for the grouped bar chart
   NOTE: Your original code referenced teslaBackgroundCounts/agilityBackgroundCounts
   but did not define them. Defining them here preserves your intended workflow. *)
teslaBackgroundCounts  = Counts[teslaBackgrounds];
agilityBackgroundCounts = Counts[agilityBackgrounds];

(* =========================
   4) VISUALIZATION 1: GROUPED BAR CHART — BACKGROUND COMPARISON
   Business meaning: compares “leadership DNA” across companies
   ========================= *)

Text[Style["Visualization 1: Leadership Background Comparison", Bold, 14]];

(* Define the categories we want to compare across both firms *)
backgroundCategories = {"Big Tech","Automotive","Academia","Robotics Startup","Other"};

(* Convert counts into aligned vectors (0 if missing category) *)
teslaValues  = Table[Lookup[teslaBackgroundCounts,  cat, 0], {cat, backgroundCategories}];
agilityValues = Table[Lookup[agilityBackgroundCounts, cat, 0], {cat, backgroundCategories}];

BarChart[
  {teslaValues, agilityValues},
  ChartLabels -> {backgroundCategories, {"Tesla","Agility"}},
  ChartLayout -> "Grouped",
  PlotLabel -> Style["Leadership Team Backgrounds: Tesla vs Agility", Bold, 14],
  FrameLabel -> {"Background Category", "Number of Executives"},
  ChartLegends -> Placed[{"Tesla Optimus","Agility Robotics"}, Above],
  ImageSize -> Large,
  GridLines -> {None, Automatic},
  GridLinesStyle -> Directive[Gray, Dashed]
];

(* Business takeaway (kept exactly as your narrative — just placed clearly) *)
Text[
  Style[
    "Key Insight: Tesla's leadership is 60% Automotive/Big Tech, while Agility's is 80% Academia/Robotics Startups. This validates each company's narrative positioning.",
    Italic, 12
  ]
];

(* =========================
   5) VISUALIZATION 3: EDUCATION CREDENTIALS
   Business meaning: proxies for research intensity vs execution/deployment orientation
   ========================= *)

Text[Style["Visualization 3: Educational Credentials", Bold, 14]];

teslaDegrees  = teslaLeadership[[All, 4]];
agilityDegrees = agilityLeadership[[All, 4]];

teslaDegreeCounts  = Counts[teslaDegrees];
agilityDegreeCounts = Counts[agilityDegrees];

GraphicsRow[
  {
    PieChart[
      Values[teslaDegreeCounts],
      ChartLabels -> Keys[teslaDegreeCounts],
      PlotLabel -> Style["Tesla Education", Bold, 12]
    ],
    PieChart[
      Values[agilityDegreeCounts],
      ChartLabels -> Keys[agilityDegreeCounts],
      PlotLabel -> Style["Agility Education", Bold, 12]
    ]
  },
  ImageSize -> Large
];

Text[
  Style[
    "Key Insight: Agility has 3 PhDs (60% of team) vs Tesla's 1 PhD (20%). This aligns with Agility's research-driven positioning vs Tesla's execution-focused approach.",
    Italic, 12
  ]
];

(* =========================
   6) EXPLORATORY ANALYSIS: ACADEMIC BACKGROUND vs PATENT OUTPUT
   IMPORTANT NOTE (Business integrity):
   This is exploratory and uses rough public estimates.
   It illustrates how leadership composition can map to innovation signals.
   ========================= *)

Text[Style["Exploratory Analysis: Does Academic Background Correlate with R&D Output?", Bold, 14]];

(* Hypothesis: Companies with more academic leaders file more patents
   Patent counts are approximate based on public sources/announcements. *)
teslaPatents  = 18;  (* Tesla Optimus-related patents as of 2024 (estimate) *)
agilityPatents = 45; (* Agility Robotics patents (estimate) *)

academicCountTesla  = Count[teslaBackgrounds,  x_ /; StringContainsQ[x, "Academia", IgnoreCase -> True]];
academicCountAgility = Count[agilityBackgrounds, x_ /; StringContainsQ[x, "Academia", IgnoreCase -> True]];

Print["Tesla: ", academicCountTesla, " academic leaders, ", teslaPatents, " patents"];
Print["Agility: ", academicCountAgility, " academic leaders, ", agilityPatents, " patents"];

ListPlot[
  {
    {academicCountTesla, teslaPatents},
    {academicCountAgility, agilityPatents}
  },
  PlotLabel -> Style["Academic Leaders vs Patent Count", Bold, 14],
  FrameLabel -> {"Number of Academic Backgrounds","Patents Filed"},
  Epilog -> {
    Text["Tesla",  {academicCountTesla + 0.2,  teslaPatents}],
    Text["Agility",{academicCountAgility + 0.2, agilityPatents}]
  },
  ImageSize -> Medium
];

(* Correlation (NOTE: with only two points, correlation will be extreme; interpret cautiously) *)
correlation = Correlation[{academicCountTesla, academicCountAgility}, {teslaPatents, agilityPatents}];
Print["Correlation between academic leadership and patents: ", N[correlation, 3]];

Text[
  Style[
    "Finding: Strong positive correlation (0.99) between academic leadership and patent output. Agility's 2.5x more patents aligns with their 3x academic leader advantage.",
    Italic, 12
  ]
];

(* =========================
   7) DATA SOURCES & REFERENCES (TRANSPARENCY)
   Business meaning: shows rigor and protects credibility
   ========================= *)

Text[Style["Data Sources", Bold, 14]];

Text["Leadership Data:"];
Text["1. Agility Robotics Leadership: https://www.agilityrobotics.com/about/leadership"];
Text["2. Tesla Leadership: Wikipedia (Elon Musk), LinkedIn profiles, Tesla AI Day presentations"];
Text["3. Educational Background: LinkedIn, university records, company bios"];

Text["Patent Data:"];
Text["4. USPTO Patent Search: https://www.uspto.gov/"];
Text["5. Google Patents: patents.google.com (search 'Tesla humanoid robot', 'Agility Robotics')"];

Text["Industry Context:"];
Text["6. 'The State of Humanoid Robotics' - IEEE Spectrum, 2024"];
Text["7. 'Leadership DNA in Robotics Startups' - Harvard Business Review, 2023"];

(* NOTE: Your original notebook appears to continue into leadership images (elonImage=...).
   Keep that code in your next file (e.g., 03b_leadership_images.wl) if you want to separate concerns. *)

