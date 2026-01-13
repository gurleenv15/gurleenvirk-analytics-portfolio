(*00 — Data Configuration & Setup

What this file does:
- Defines the target URLs for Tesla and Agility Robotics.
- Creates a plaintext import helper.
- Imports Agility site text directly (works reliably).
- Uses manual Tesla text (because Tesla's site is heavily scripted/encrypted).
- Defines a helper function to compute top word counts.

Why this matters:
This step standardizes the text inputs used for downstream analysis, ensuring we are comparing
the narrative content each company presents publicly.
*)

teslaAboutURL = "https://www.tesla.com/about";
agilityURL = "https://agilityrobotics.com";

Clear[importPlainText];
importPlainText[url_String] := Import[url, "Plaintext"];

agilityText = importPlainText[agilityURL];

(*Because Tesla's corporate sites is built with encrypted and heavily scripted front-ends, we manually imported the text*)
teslaText = "
About Us
Accelerating the World's Transition to Sustainable Energy

100k+
Employees

One Mission

20.4 Mmt1
CO2e Avoided in 2023

The Future is Sustainable
We\[CloseCurlyQuote]re building a world powered by solar energy, \
running on batteries and transported by electric vehicles. Explore \
the most recent impact of our products, people and supply chain.

Explore Impact
Scalable energy generation and storage products
We design sustainable systems that are massively \
scalable\[LongDash]resulting in the greatest environmental benefit \
possible. Our energy generation and storage products work together \
with our electric vehicles to amplify their impact. Our master plans \
share our vision for a sustainable future and what we are doing about \
it. Read Tesla's Master Plans
Power Earth
Home powered by Tesla energy products
Tesla Powerwall
Tesla electric vehicle

Solar
Produce solar energy for residential and commercial needs


Batteries
Install batteries to store clean energy


Electric Vehicles
Make badass, zero-emission vehicles that can charge with clean energy


Our vehicles are some of the safest in the world. After safety, our \
goal is to make every Tesla the most fun you could possibly have in a \
vehicle. We build features that make being in your vehicle more \
enjoyable\[LongDash]from gaming to movies, easter eggs and more. With \
over-the-air software updates, we regularly introduce features at the \
push of a button.
Make it (Ridiculously) Fun
Tesla manufacturing machinery 
To shift humanity away from fossil fuels, we need extreme scale. \
Headquartered in Texas, we operate six huge, vertically integrated \
factories across three continents. With over 100,000 employees, our \
teams design, build, sell and service our products in-house.
The Machine That Builds the Machine
Tesla manufacturing machinery 
Using a first-principles approach, we solve some of the \
world\[CloseCurlyQuote]s biggest problems. If you\[CloseCurlyQuote]ve \
done exceptional work, join us in tackling the next generation of \
engineering, manufacturing and operational challenges.
The Tesla Team

Join Us
See Jobs
1 20.4 million metric tons is equivalent to over 48 billion miles of \
driving.

Tesla participates in the E-Verify Program.

Tesla is an Equal Opportunity employer. All qualified applicants will \
receive consideration for employment without regard to any factor, \
including veteran status and disability status, protected by \
applicable federal, state or local laws.

Tesla is also committed to working with and providing reasonable \
accommodations to individuals with disabilities. Let your recruiter \
know if you need an accommodation at any point during the interview \
process.

For quick access to screen reading technology compatible with this \
site, download a free compatible screen reader (view the free \
step-by-step tutorial). Contact ADA@tesla.com for additional \
information or to request accommodations.

Footer menu
Tesla © 2025
Privacy & Legal
Vehicle Recalls
Contact
News
Get Updates
Locations
Learn AI & Robotics
We develop and deploy autonomy at scale in vehicles, robots and more. \
We believe that an approach based on advanced AI for vision and \
planning, supported by efficient use of inference hardware, is the \
only way to achieve a general solution for full self-driving, \
bi-pedal robotics and beyond.

Tesla Optimus
Create a general purpose, bi-pedal, autonomous humanoid robot capable \
of performing unsafe, repetitive or boring tasks. Achieving that end \
goal requires building the software stacks that enable balance, \
navigation, perception and interaction with the physical world. \
We\[CloseCurlyQuote]re hiring deep learning, computer vision, motion \
planning, controls, mechanical and general software engineers to \
solve some of our hardest engineering challenges.

See Opportunities

Tesla Bot
FSD Chip
Build AI inference chips to run our Full Self-Driving software, \
considering every small architectural and micro-architectural \
improvement while squeezing maximum silicon performance-per-watt. \
Perform floor-planning, timing and power analyses on the design. \
Write robust tests and scoreboards to verify functionality and \
performance. Implement drivers to program and communicate with the \
chip, focusing on performance optimization and redundancy. Finally, \
validate the silicon chip and bring it to mass production in our \
vehicles.

FSD Chip Hardware
Neural Networks
Apply cutting-edge research to train deep neural networks on problems \
ranging from perception to control. Our per-camera networks analyze \
raw images to perform semantic segmentation, object detection and \
monocular depth estimation. Our birds-eye-view networks take video \
from all cameras to output the road layout, static infrastructure and \
3D objects directly in the top-down view. Our networks learn from the \
most complicated and diverse scenarios in the world, iteratively \
sourced from our fleet of millions of vehicles in real time. A full \
build of Autopilot neural networks involves 48 networks that take \
70,000 GPU hours to train 🔥. Together, they output 1,000 distinct \
tensors (predictions) at each timestep.
...
Locations
Learn";

Clear[getTopWordCounts];
getTopWordCounts[text_String, n_Integer : 20] :=
 Module[{words, cleaned, counts},
  words = TextWords[ToLowerCase[text]];
  cleaned = DeleteStopwords[words];
  counts = Counts[cleaned];
  TakeLargest[counts, n]
 ];
