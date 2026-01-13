## Source Code Structure

This folder contains modular Wolfram Language (`.wl`) files. Each file focuses on a specific analytical question 

## src/ — Wolfram Analysis Modules

This folder contains the Wolfram Language scripts (`.wl`) used to reproduce the analysis in a modular, readable way.  
Each file corresponds to one major section of the project narrative 
(text branding → visuals → leadership → investment → synthesis).

1. `00_config_and_setup.wl`  
   **What it does:** Defines source URLs, imports/sets the core text inputs, and creates shared helper functions used across modules.  
   **Why it matters:** Establishes consistent, reproducible inputs so all downstream analysis is comparable.

2. `01_text_branding_wordclouds.wl`  
   **What it does:** Computes top word frequencies and generates word clouds for Tesla vs Agility.  
   **Why it matters:** Highlights how each company frames humanoid labor through language (vision/AI vs deployment/utility).

3. `02_visual_storytelling_image_tagging.wl`  
   **What it does:** Attempts to import website images; if import fails, generates placeholders; applies manual theme tagging; produces an image comparison grid + theme frequency chart.  
   **Why it matters:** Visual storytelling signals credibility and go-to-market posture (futuristic vision vs operational readiness).

4. `03_leadership_backgrounds.wl`  
   **What it does:** Organizes and analyzes leadership background signals (roles, expertise, strategic orientation) for each company.  
   **Why it matters:** Leadership profiles help validate whether branding claims align with execution capability.

5. `04_investment_angle_humn_vs_tsla.wl`  
   **What it does:** Compares concentrated exposure (Tesla) vs diversified exposure (HUMN ETF) for humanoid robotics-related investing.  
   **Why it matters:** Connects the narrative analysis to a practical investment decision framework.

### Final Write-Up
6. `05_sythesis_and_recommendation.md`  
   **What it does:** Summarizes the full argument and recommendation in plain English.  
   **Why it matters:** This is the executive-facing conclusion that ties the analytics to decision-making.




Each file includes explanatory comments that translate analytical steps into business and strategic insight.
