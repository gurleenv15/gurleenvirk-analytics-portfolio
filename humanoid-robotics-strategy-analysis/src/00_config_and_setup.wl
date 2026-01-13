(*Purpose: This section defines the public sources used for the narrative comparison and creates a consistent text-ingestion pipeline for both companies. We attempt to import plain text directly from each company’s website, but Tesla’s site is heavily scripted, so we manually paste the text to ensure we analyze the actual branding language. This setup stage ensures the downstream text analysis (top words, word clouds, keyword comparisons) is reproducible and based on comparable inputs.
(*
Module: 00 — Data Configuration & Setup
Project: Branding the Robot Worker (Tesla vs Agility Robotics)

Core Question:
How do Tesla and Agility Robotics visually and narratively position humanoid robots as the future of factory work?

Purpose:
This setup module defines source URLs and establishes a consistent way to ingest text from public websites.
We attempt to import plain text directly from both companies. Agility's site can be imported directly,
but Tesla's corporate site is heavily scripted/encrypted, so we manually paste Tesla text to ensure the
analysis reflects the actual branding language.

Outputs:
- teslaText and agilityText are created as the standardized inputs for downstream text analysis.
*)

(* ----------------------------- *)
(* 1) Data source URLs           *)
(* ----------------------------- *)

teslaAboutURL = "https://www.tesla.com/about";
agilityURL   = "https://agilityrobotics.com";

(* ----------------------------- *)
(* 2) Plaintext import helper    *)
(* ----------------------------- *)

Clear[importPlainText];
importPlainText[url_String] := Import[url, "Plaintext"];

(* Pull Agility text directly (works reliably) *)
agilityText = importPlainText[agilityURL];

(* Tesla note:
   Tesla pages are heavily scripted; Import[..., "Plaintext"] often returns incomplete content.
   To keep the analysis accurate and reproducible, we manually paste the relevant Tesla text. *)
teslaText = "
About Us
Accelerating the World's Transition to Sustainable Energy

100k+
Employees

One Mission

20.4 Mmt1
CO2e Avoided in 2023

The Future is Sustainable
We’re building a world powered by solar energy, running on batteries and transported by electric vehicles.
...

Learn AI & Robotics
We develop and deploy autonomy at scale in vehicles, robots and more. We believe that an approach based
on advanced AI for vision and planning, supported by efficient use of inference hardware, is the only way
to achieve a general solution for full self-driving, bi-pedal robotics and beyond.

Tesla Optimus
Create a general purpose, bi-pedal, autonomous humanoid robot capable of performing unsafe, repetitive or
boring tasks. Achieving that end goal requires building the software stacks that enable balance, navigation,
perception and interaction with the physical world.
...
";

(* ----------------------------- *)
(* 3) Word-count utility function *)
(* ----------------------------- *)

Clear[getTopWordCounts];
getTopWordCounts[text_String, n_Integer : 20] :=
 Module[{words, cleaned, counts},
  words = TextWords[ToLowerCase[text]];
  cleaned = DeleteStopwords[words];
  counts = Counts[cleaned];
  TakeLargest[counts, n]
 ];

(* ----------------------------- *)
(* 4) Quick sanity checks        *)
(* ----------------------------- *)

teslaTopWords  = getTopWordCounts[teslaText, 25];
agilityTopWords = getTopWordCounts[agilityText, 25];

teslaTopWords
agilityTopWords

