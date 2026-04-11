# ============================================================
# Compute GVA-weighted energy cost share for upstream industries
# using ONS Input-Output Analytical Tables (product by product)
#
# Downloads xlsx directly from ONS, reads the IOT sheet,
# and computes GVA-weighted average energy cost shares.
#
# For calibration of the model parameter $\alpha^U = 0.375$.
#
# ============================================================


library(tidyverse)
library(readxl)    # install.packages("readxl") if needed

# --- Source URLs by year ---
urls <- list(
  "2017" = "https://www.ons.gov.uk/file?uri=/economy/nationalaccounts/supplyandusetables/datasets/ukinputoutputanalyticaltablesdetailed/2017/nasu1719pr.xlsx",
  "2018" = "https://www.ons.gov.uk/file?uri=/economy/nationalaccounts/supplyandusetables/datasets/ukinputoutputanalyticaltablesdetailed/2018/nasu1719pr.xlsx",
  "2019" = "https://www.ons.gov.uk/file?uri=/economy/nationalaccounts/supplyandusetables/datasets/ukinputoutputanalyticaltablesdetailed/2019/nasu1719pr.xlsx",
  "2020" = "https://www.ons.gov.uk/file?uri=/economy/nationalaccounts/supplyandusetables/datasets/ukinputoutputanalyticaltablesdetailed/2020/iot2020product.xlsx",
  "2021" = "https://www.ons.gov.uk/file?uri=/economy/nationalaccounts/supplyandusetables/datasets/ukinputoutputanalyticaltablesdetailed/2021/iot2021product.xlsx",
  "2022" = "https://www.ons.gov.uk/file?uri=/economy/nationalaccounts/supplyandusetables/datasets/ukinputoutputanalyticaltablesdetailed/2022revised/iot2022revisedproduct.xlsx"
)

# --- Helper: parse £m values with commas and quotes ---
parse_val <- function(x) {
  x <- str_remove_all(as.character(x), '[",]')
  as.numeric(x)
}

# --- Download / load path function ---
get_iot_excel_path <- function(year, urls, input_dir = "input", download = FALSE) {
  key <- as.character(year)
  url <- urls[[key]]

  if (is.null(url)) {
    stop(sprintf("No download URL found for year %s", key))
  }

  if (!dir.exists(input_dir)) dir.create(input_dir, recursive = TRUE)

  xlsx_path <- file.path(input_dir, sprintf("iot%dproduct.xlsx", year))

  if (download) {
    download.file(url, xlsx_path, mode = "wb")
  } else if (!file.exists(xlsx_path)) {
    stop(sprintf(
      "File not found: %s. Set download = TRUE to fetch from ONS.",
      xlsx_path
    ))
  }

  xlsx_path
}

# --- Target upstream industries ---
targets <- tribble(
  ~sic,        ~name,
  "CPA_D351",      "Electric power generation",
  "CPA_D352_3",    "Gas manufacture & distribution",
  "CPA_C20A",      "Industrial gases, inorganics, fertilisers",
  "CPA_C20B",      "Petrochemicals",
  "CPA_C17",       "Paper and paper products",
  "CPA_C23OTHER",  "Glass, ceramics, stone",
  "CPA_C241_3",  "Basic iron and steel",
  "CPA_C244_5",    "Other basic metals & casting"
)

# --- Processing-only function ---
process_iot_file <- function(xlsx_path, year, targets) {
  sheets <- excel_sheets(xlsx_path)
  iot_sheet <- sheets[str_detect(sheets, regex("IOT|domestic use", ignore_case = TRUE))][1]

  if (is.na(iot_sheet)) {
    stop(sprintf("No IOT/domestic-use sheet found in %s", xlsx_path))
  }

  raw <- read_excel(xlsx_path, sheet = iot_sheet, col_names = FALSE, skip = 3)

  # Row 1 (after skip) = SIC codes as column headers
  sic_codes <- as.character(raw[1, ])
  sic_codes[1] <- "row_code"
  sic_codes[2] <- "row_name"
  colnames(raw) <- sic_codes

  # Remove header rows (rows 1-3: SIC header, industry names, blank CPA row)
  df <- raw[-(1:3), ]

  # Extract key rows
  elec <- df %>% filter(row_code == "CPA_D351")
  gas  <- df %>% filter(row_code == "CPA_D352_3")
  gva  <- df %>% filter(row_code == "GVA")
  outp <- df %>% filter(row_code == "P1")

  targets %>%
    rowwise() %>%
    mutate(
      year = year,
      elec_cost = parse_val(elec[sic]),
      gas_cost = parse_val(gas[sic]),
      energy_cost = elec_cost + gas_cost,
      gross_output = parse_val(outp[sic]),
      gva_level = parse_val(gva[sic]),
      energy_share = energy_cost / gross_output
    ) %>%
    ungroup() %>%
    select(year, sic, name, elec_cost, gas_cost, energy_cost, gross_output, gva_level, energy_share)
}

# --- Run for all years (2017-2022) and keep long-format output ---
years <- 2017:2022
download_files <- FALSE

results <- map_dfr(years, function(y) {
  file_path <- get_iot_excel_path(y, urls, download = download_files)
  process_iot_file(file_path, y, targets)
})

# Optional quick check in console
results %>%
  mutate(energy_share_pct = round(100 * energy_share, 2)) %>%
  arrange(year, sic) %>%
  print(n = Inf)

energy_share <- results %>%
  group_by(year) %>%
  summarise(
    sum_energy_cost = sum(energy_cost),
    sum_gross_output = sum(gross_output)
  ) %>%
  mutate(energy_share_all8 = sum_energy_cost / sum_gross_output)

energy_share %>%
  ggplot(aes(x = year, y = energy_share_all8 * 100)) +
  geom_line() +
  geom_point() +
  labs(title = "Energy Cost Share (All 8 Industries)", x = "Year", y = "Energy Cost Share (%)") +
  theme_minimal() +
  geom_hline(yintercept = 0.375 * 100, linetype = "dashed", color = "red")

# --- Year-by-year GVA-weighted averages from long-format `results` ---
gva_weighted_by_year <- results %>%
  group_by(year) %>%
  summarise(
    weighted_avg_all8 = sum(energy_share * gva_level, na.rm = TRUE) / sum(gva_level, na.rm = TRUE),
    weighted_avg_excl_energy = sum(if_else(!sic %in% c("CPA_D351", "CPA_D352_3"), energy_share * gva_level, 0), na.rm = TRUE) /
      sum(if_else(!sic %in% c("CPA_D351", "CPA_D352_3"), gva_level, 0), na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    weighted_avg_all8_pct = 100 * weighted_avg_all8,
    weighted_avg_excl_energy_pct = 100 * weighted_avg_excl_energy
  )

print(gva_weighted_by_year, n = Inf)

gva_weighted_by_year %>%
  ggplot(aes(x = year, y = weighted_avg_all8_pct)) +
  geom_line() +
  geom_point() +
  labs(title = "GVA-Weighted Average Energy Share (All 8 Industries)", x = "Year", y = "Weighted Average (%)") +
  theme_minimal()
