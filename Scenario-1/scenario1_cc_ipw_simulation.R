# ============================================================
# Scenario 1: R | X and Y | X
#
# Missingness model:
#   logit P(R = 1 | X) = beta0 + beta1 * X
#
# Outcome model:
#   logit P(Y = 1 | X) = gamma0 + gamma1 * X
#
# Methods:
#   1. Complete Case (CC)
#   2. Inverse Probability Weighting (IPW)
#
# Monte Carlo performance measures:
#   - Mean estimate
#   - Bias
#   - Empirical standard deviation
#   - Mean model-based standard error
#   - Mean squared error
#   - Average missingness rate
# ============================================================

set.seed(123)

simulate_scenario1 <- function(
  n_size = 2000,
  p_x1 = 0.5,
  beta0 = 0.5,
  beta1 = -0.6,
  gamma0 = 6,
  gamma1 = -10
) {

  # ----------------------------------------------------------
  # 1. Generate binary covariate X
  # ----------------------------------------------------------

  x_true <- rbinom(
    n = n_size,
    size = 1,
    prob = p_x1
  )

  # ----------------------------------------------------------
  # 2. Generate observation indicator R
  #
  # P(R = 1 | X)
  # ----------------------------------------------------------

  p_obs <- plogis(
    beta0 + beta1 * x_true
  )

  r_ind <- rbinom(
    n = n_size,
    size = 1,
    prob = p_obs
  )

  # ----------------------------------------------------------
  # 3. Generate binary outcome Y
  #
  # P(Y = 1 | X)
  # ----------------------------------------------------------

  p_y <- plogis(
    gamma0 + gamma1 * x_true
  )

  y <- rbinom(
    n = n_size,
    size = 1,
    prob = p_y
  )

  # ----------------------------------------------------------
  # 4. Create observed version of X
  # ----------------------------------------------------------

  x_seen <- x_true
  x_seen[r_ind == 0] <- NA

  miss_rate <- mean(is.na(x_seen))

  # ----------------------------------------------------------
  # 5. Complete Case analysis
  # ----------------------------------------------------------

  fit_cc <- tryCatch(
    glm(
      y ~ x_seen,
      family = binomial
    ),
    error = function(e) NULL
  )

  if (is.null(fit_cc)) {

    gamma0_cc <- NA_real_
    gamma1_cc <- NA_real_

    se_gamma0_cc <- NA_real_
    se_gamma1_cc <- NA_real_

  } else {

    cc_coef <- summary(fit_cc)$coefficients

    gamma0_cc <- cc_coef["(Intercept)", "Estimate"]
    gamma1_cc <- cc_coef["x_seen", "Estimate"]

    se_gamma0_cc <- cc_coef["(Intercept)", "Std. Error"]
    se_gamma1_cc <- cc_coef["x_seen", "Std. Error"]
  }

  # ----------------------------------------------------------
  # 6. IPW analysis
  #
  # Correctly specified weights:
  #   1 / P(R = 1 | X)
  # ----------------------------------------------------------

  fit_ipw <- tryCatch(
    glm(
      y ~ x_seen,
      family = binomial,
      weights = r_ind / p_obs
    ),
    error = function(e) NULL
  )

  if (is.null(fit_ipw)) {

    gamma0_ipw <- NA_real_
    gamma1_ipw <- NA_real_

    se_gamma0_ipw <- NA_real_
    se_gamma1_ipw <- NA_real_

  } else {

    ipw_coef <- summary(fit_ipw)$coefficients

    gamma0_ipw <- ipw_coef["(Intercept)", "Estimate"]
    gamma1_ipw <- ipw_coef["x_seen", "Estimate"]

    se_gamma0_ipw <- ipw_coef["(Intercept)", "Std. Error"]
    se_gamma1_ipw <- ipw_coef["x_seen", "Std. Error"]
  }

  # ----------------------------------------------------------
  # 7. Return results from one simulated dataset
  # ----------------------------------------------------------

  list(
    gamma0_cc = gamma0_cc,
    gamma1_cc = gamma1_cc,
    se_gamma0_cc = se_gamma0_cc,
    se_gamma1_cc = se_gamma1_cc,

    gamma0_ipw = gamma0_ipw,
    gamma1_ipw = gamma1_ipw,
    se_gamma0_ipw = se_gamma0_ipw,
    se_gamma1_ipw = se_gamma1_ipw,

    miss_rate = miss_rate
  )
}


# ============================================================
# Monte Carlo simulation
# ============================================================

n_rep <- 500

simulation_results <- replicate(
  n = n_rep,
  expr = simulate_scenario1(),
  simplify = FALSE
)


# ============================================================
# Extract parameter estimates
# ============================================================

gamma0_cc_values <- vapply(
  simulation_results,
  function(x) x$gamma0_cc,
  numeric(1)
)

gamma1_cc_values <- vapply(
  simulation_results,
  function(x) x$gamma1_cc,
  numeric(1)
)

gamma0_ipw_values <- vapply(
  simulation_results,
  function(x) x$gamma0_ipw,
  numeric(1)
)

gamma1_ipw_values <- vapply(
  simulation_results,
  function(x) x$gamma1_ipw,
  numeric(1)
)


# ============================================================
# Extract model-based standard errors
# ============================================================

se_gamma0_cc_values <- vapply(
  simulation_results,
  function(x) x$se_gamma0_cc,
  numeric(1)
)

se_gamma1_cc_values <- vapply(
  simulation_results,
  function(x) x$se_gamma1_cc,
  numeric(1)
)

se_gamma0_ipw_values <- vapply(
  simulation_results,
  function(x) x$se_gamma0_ipw,
  numeric(1)
)

se_gamma1_ipw_values <- vapply(
  simulation_results,
  function(x) x$se_gamma1_ipw,
  numeric(1)
)


# ============================================================
# Extract missingness rates
# ============================================================

missing_rates <- vapply(
  simulation_results,
  function(x) x$miss_rate,
  numeric(1)
)


# ============================================================
# True outcome-model parameters
# ============================================================

true_gamma0 <- 6
true_gamma1 <- -10


# ============================================================
# Complete Case summary
# ============================================================

summary_cc <- c(
  mean_gamma0 = mean(gamma0_cc_values, na.rm = TRUE),
  mean_gamma1 = mean(gamma1_cc_values, na.rm = TRUE),

  bias_gamma0 =
    mean(gamma0_cc_values, na.rm = TRUE) - true_gamma0,

  bias_gamma1 =
    mean(gamma1_cc_values, na.rm = TRUE) - true_gamma1,

  empirical_sd_gamma0 =
    sd(gamma0_cc_values, na.rm = TRUE),

  empirical_sd_gamma1 =
    sd(gamma1_cc_values, na.rm = TRUE),

  mean_se_gamma0 =
    mean(se_gamma0_cc_values, na.rm = TRUE),

  mean_se_gamma1 =
    mean(se_gamma1_cc_values, na.rm = TRUE),

  mse_gamma0 =
    mean(
      (gamma0_cc_values - true_gamma0)^2,
      na.rm = TRUE
    ),

  mse_gamma1 =
    mean(
      (gamma1_cc_values - true_gamma1)^2,
      na.rm = TRUE
    ),

  average_missing_rate =
    mean(missing_rates, na.rm = TRUE)
)


# ============================================================
# IPW summary
# ============================================================

summary_ipw <- c(
  mean_gamma0 = mean(gamma0_ipw_values, na.rm = TRUE),
  mean_gamma1 = mean(gamma1_ipw_values, na.rm = TRUE),

  bias_gamma0 =
    mean(gamma0_ipw_values, na.rm = TRUE) - true_gamma0,

  bias_gamma1 =
    mean(gamma1_ipw_values, na.rm = TRUE) - true_gamma1,

  empirical_sd_gamma0 =
    sd(gamma0_ipw_values, na.rm = TRUE),

  empirical_sd_gamma1 =
    sd(gamma1_ipw_values, na.rm = TRUE),

  mean_se_gamma0 =
    mean(se_gamma0_ipw_values, na.rm = TRUE),

  mean_se_gamma1 =
    mean(se_gamma1_ipw_values, na.rm = TRUE),

  mse_gamma0 =
    mean(
      (gamma0_ipw_values - true_gamma0)^2,
      na.rm = TRUE
    ),

  mse_gamma1 =
    mean(
      (gamma1_ipw_values - true_gamma1)^2,
      na.rm = TRUE
    ),

  average_missing_rate =
    mean(missing_rates, na.rm = TRUE)
)


# ============================================================
# Display results
# ============================================================

summary_cc
summary_ipw
