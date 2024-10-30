# Forecast 2024 US election

## Overview

This repository contains the analysis and methodology used to predict the outcome of the 2024 U.S. Presidential election. The primary objective is to forecast the popular vote and Electoral College results for the two major candidates: Kamala Harris (Democrat) and Donald Trump (Republican), based on aggregated polling data. The project incorporates statistical modeling, demographic analysis, and discussions on polling methodologies to provide a robust election prediction. This repository provides readers with all the necessary data, R scripts, and files to understand and reproduce an analysis of the 2024 US election prediction based on the poll of polls.

## File Structure

The repository is structured as follows:

-   `data/raw_data` contains the raw poll data as obtained from [FiveThirtyEight](https://projects.fivethirtyeight.com/polls/president-general/2024/national/), by searching for "Download the data", then selecting Presidential general election polls (current cycle), then "Download".To open these data through GitHub, they can be downloaded. Alternatively, to view these files within RStudio, they can be imported using the library `readr`.
-   `data/02-analysis_data` contains the cleaned dataset constructed in `scripts/03-clean_data`.
-   The `scripts` folder contains the R scripts and code that simulated, tested, downloaded, and cleaned the data.
-   `model` contains fitted models.
-   `other` contains details about LLM chat interactions and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper.


## Statement on LLM usage

Aspects of the code were written with the help of Copilot and ChatGPT4o. The whole writing process, including generating, polishing, and checking grammar was written with the help of ChatGPT4o and the entire chat history is available in other/llms/usage.txt.
