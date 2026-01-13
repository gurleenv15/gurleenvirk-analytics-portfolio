(*
02 — Visual Storytelling (Image Import + Manual Theme Tagging)

What this file does:
- Defines target URLs for pulling example images.
- Attempts to import images from each site.
- If imports fail (common for modern websites), generates placeholders that represent the intended scene.
- Manually tags each sample image with themes (vision vs utility).
- Visualizes the comparison via an image grid and a theme frequency bar chart.

Why this matters:
Visual storytelling is a credibility signal. Images communicate whether a robot is positioned as
a near-term worker (warehouse realism) or a long-horizon AI vision (futuristic lab aesthetic).
*)

(*---1. DEFINE TARGET URLS ---*)
urlTesla = "https://www.tesla.com/about";
urlAgility = "https://www.agilityrobotics.com/about/press";

(*---2. ROBUST IMPORT FUNCTION ---*)
getImageSample[url_, companyName_] :=
 Module[{imgs, placeholderStyle},
  (*Set style based on Company Identity*)
  placeholderStyle =
   If[companyName == "Tesla", {Black, EdgeForm[White]}, (*Tesla: High Contrast/Dark*)
    {White, EdgeForm[RGBColor[0, 0.6, 0.8]]} (*Agility:Teal/Bright*)];

  (*Attempt Import*)
  imgs = Quiet[Check[Import[url, "Images"], {}]];

  (* Import failed, generated Placeholders*)
  If[Length[imgs] < 2,
   Switch[companyName,
    "Tesla",
    {Graphics[{Black, Rectangle[{0, 0}, {4, 3}], White,
       Style[Text["TESLA HERO:\nSolo Optimus\n(Clean Lab)", {2, 1.5}], 14, Bold]}, ImageSize -> 200],
     Graphics[{GrayLevel[0.2], Rectangle[{0, 0}, {4, 3}], White,
       Style[Text["TESLA DETAIL:\nActuator/Hand\n(Hardware Focus)", {2, 1.5}], 14, Bold]}, ImageSize -> 200]},
    "Agility",
    {Graphics[{White, Rectangle[{0, 0}, {4, 3}], RGBColor[0, 0.6, 0.8],
       Style[Text["AGILITY HERO:\nDigit Lifting Tote\n(Warehouse Floor)", {2, 1.5}], 14, Bold]}, ImageSize -> 200],
     Graphics[{LightGray, Rectangle[{0, 0}, {4, 3}], Orange,
       Style[Text["AGILITY ACTION:\nHuman Co-Work\n(Safety Gear)", {2, 1.5}], 14, Bold]}, ImageSize -> 200]}],
   Take[imgs, UpTo[2]] (*Use real images if download succeeds*)
   ]
  ];

(*Fetch Data*)
teslaImages = getImageSample[urlTesla, "Tesla"];
agilityImages = getImageSample[urlAgility, "Agility"];

(*---3. MANUAL THEME TAGGING ---*)
(*We manually assigned tags based on themes we saw from the images on the website,
because we were unable to actually import directly from the websites*)

taggedData = {
  (*Tesla Image 1*)
  <|"Company" -> "Tesla", "Image" -> teslaImages[[1]],
    "Tags" -> {"Futuristic", "Solo Robot", "AI", "Clean Lab"}|>,
  (*Tesla Image 2*)
  <|"Company" -> "Tesla", "Image" -> teslaImages[[2]],
    "Tags" -> {"Innovation", "Hardware", "Minimalist"}|>,
  (*Agility Image 1*)
  <|"Company" -> "Agility", "Image" -> agilityImages[[1]],
    "Tags" -> {"Logistics", "Warehouse", "Work", "Realism"}|>,
  (*Agility Image 2*)
  <|"Company" -> "Agility", "Image" -> agilityImages[[2]],
    "Tags" -> {"Human-Robot Collab", "Safety", "Utilitarian"}|>
  };

(*---4. VISUALIZATION---*)

(*A.Calculate Theme Counts*)
allTags = Flatten[taggedData[[All, "Tags"]]];
tagCounts = Counts[allTags];

(*B.Generate Comparison Image Grid*)
imageGrid =
 Grid[{
   {Style["TESLA (The Visionary)", 16, Bold, Red],
    Style["AGILITY (The Pragmatist)", 16, Bold, RGBColor[0, 0.6, 0.8]]},
   {Column[{taggedData[[1, "Image"]],
      Style[Row[taggedData[[1, "Tags"]], ", "], 10, Italic],
      Spacer[10],
      taggedData[[2, "Image"]],
      Style[Row[taggedData[[2, "Tags"]], ", "], 10, Italic]},
     Alignment -> Center],
    Column[{taggedData[[3, "Image"]],
      Style[Row[taggedData[[3, "Tags"]], ", "], 10, Italic],
      Spacer[10],
      taggedData[[4, "Image"]],
      Style[Row[taggedData[[4, "Tags"]], ", "], 10, Italic]},
     Alignment -> Center]}
   },
  Frame -> All, FrameStyle -> GrayLevel[0.8], Spacings -> {2, 2}
  ];

(*C.Generate Bar Chart*)
themeChart =
 BarChart[tagCounts, ChartLabels -> Placed[Keys[tagCounts], Above],
  ChartStyle -> "Pastel",
  PlotLabel -> Style["Visual Theme Frequency: Vision vs. Utility", 18, Bold],
  AxesLabel -> {None, "Frequency"}, ImageSize -> Large];

(*---5. OUTPUT---*)
Print[Style["3.1 & 3.2: Image Import & Tagging Analysis", 20, Bold]];
Print[imageGrid];
Print[Style["3.3: Theme Count Visualization", 20, Bold]];
themeChart

