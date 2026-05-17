# Codes

Candidate number: 61980

## Energy prices and inflation data (Figure 1):
- inflation_energy_prices.qmd: R script to fetch data from FRED (requires API key) and generate Figure 1

## Dynare simulation (Figures 3, 4, 5, and A2):
- inflation.mod: benchmark model dynare mod file (Credit: Kevin Sheedy)
- inflation_network_realwage_fix: extended model dynare mod file
- master.md: MATLAB script to execute the two models and to generate Figures 3, 4, 5, and A2

## Energy cost share calculation (Table A.1 and Figure A.1)
- energy_cost_share.R: R script to fetch UK Input-Output Analytical Tables from the ONS website, to calculate the energy cost shares, and to generate Table A.1 and Figure A.1