# ============================================================
# Scenario 3: R | X, U and Y | X, U
#
# Missingness model:
#   logit P(R = 1 | X, U)
#     = beta0 + beta1 * X + beta2 * U
#
# Outcome model:
#   logit P(Y = 1 | X, U)
#     = gamma0 + gamma1 * X + gamma2 * U
#
# Methods:
#   1. Complete Case (CC)
#   2. Correctly specified Inverse Probability Weighting (IPW)
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

simulate_scenario3 <- function(
  n_size = 500,
  p_x1 = 0.5,
  p_u1 = 0.4,
  beta0 = -0.8,
  beta1 = -0.1,
  beta2 = 0.4,
  gamma0 = 0.3,
  gamma1 = -0.8,
  gamma2 = 0.5
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
  # 2. Generate binary latent variable U
  # ----------------------------------------------------------

  u_true <- rbinom(
    n = n_size,
    size = 1,
    prob = p_u1
  )

  # ----------------------------------------------------------
  # 3. Generate observation indicator R
  #
  # P(R = 1 | X, U)
  # ----------------------------------------------------------

  p_obs <- plogis(
    beta0 +
      beta1 * x_true +
      beta2 * u_true
  )

  r_ind <- rbinom(
    n = n_size,
    size = 1,
    prob = p_obs
  )

  # ----------------------------------------------------------
  # 4. Generate binary outcome Y
  #
  # P(Y = 1 | X, U)
  # ----------------------------------------------------------

  p_y <- plogis(
    gamma0 +
      gamma1 * x_true +
      gamma2 * u_true
  )

  y <- rbinom(
    n = n_size,
    size = 1,
    prob = p_y
  )

  # ----------------------------------------------------------
  # 5. Create observed versions of X and U
  # ----------------------------------------------------------

  x_seen <- x_true
  u_seen <- u_true

  x_seen[r_ind == 0] <- NA
  u_seen[r_ind == 0] <- NA

  miss_rate <- mean(r_ind == 0)

  # ----------------------------------------------------------
  # 6. Complete Case analysis
  #
  # Correctly specified outcome model:
  #   Y ~ X + U
  # ----------------------------------------------------------

  fit_cc <- tryCatch(
    glm(
      y ~ x_seen + u_seen,
      family = binomial
    ),
    error = function(e) NULL
  )

  if (is.null(fit_cc)) {

    gamma0_cc <- NA_real_
    gamma1_cc <- NA_real_
    gamma2_cc <- NA_real_

    se_gamma0_cc <- NA_real_
    se_gamma1_cc <- NA_real_
    se_gamma2_cc <- NA_real_

  } else {

    cc_coef <- summary(fit_cc)$coefficients

    gamma0_cc <- cc_coef["(Intercept)", "Estimate"]
    gamma1_cc <- cc_coef["x_seen", "Estimate"]
    gamma2_cc <- cc_coef["u_seen", "Estimate"]

    se_gamma0_cc <- cc_coef["(Intercept)", "Std. Error"]
    se_gamma1_cc <- cc_coef["x_seen", "Std. Error"]
    se_gamma2_cc <- cc_coef["u_seen", "Std. Error"]
  }

  # ----------------------------------------------------------
  # 7. Correctly specified IPW analysis
  #
  # Observation probability:
  #   P(R = 1 | X, U)
  #
  # Outcome model:
  #   Y ~ X + U
  # ----------------------------------------------------------

  fit_ipw <- tryCatch(
    glm(
      y ~ x_seen + u_seen,
      family = binomial,
      weights = r_ind / p_obs
    ),
    error = function(e) NULL
  )

  if (is.null(fit_ipw)) {

    gamma0_ipw <- NA_real_
    gamma1_ipw <- NA_real_
    gamma2_ipw <- NA_real_

    se_gamma0_ipw <- NA_real_
    se_gamma1_ipw <- NA_real_
    se_gamma2_ipw <- NA_real_

  } else {

    ipw_coef <- summary(fit_ipw)$coefficients

    gamma0_ipw <- ipw_coef["(Intercept)", "Estimate"]
    gamma1_ipw <- ipw_coef["x_seen", "Estimate"]
    gamma2_ipw <- ipw_coef["u_seen", "Estimate"]

    se_gamma0_ipw <- ipw_coef["(Intercept)", "Std. Error"]
    se_gamma1_ipw <- ipw_coef["x_seen", "Std. Error"]
    se_gamma2_ipw <- ipw_coef["u_seen", "Std. Error"]
  }

  # ----------------------------------------------------------
  # 8. Return results from one simulated dataset
  # ----------------------------------------------------------

  list(
    gamma0_cc = gamma0_cc,
    gamma1_cc = gamma1_cc,
    gamma2_cc = gamma2_cc,

    se_gamma0_cc = se_gamma0_cc,
    se_gamma1_cc = se_gamma1_cc,
    se_gamma2_cc = se_gamma2_cc,

    gamma0_ipw = gamma0_ipw,
    gamma1_ipw = gamma1_ipw,
    gamma2_ipw = gamma2_ipw,

    se_gamma0_ipw = se_gamma0_ipw,
    se_gamma1_ipw = se_gamma1_ipw,
    se_gamma2_ipw = se_gamma2_ipw,

    miss_rate = miss_rate
  )
}


# ============================================================
# Monte Carlo simulation
# ============================================================

n_rep <- 500

simulation_results <- replicate(
  n = n_rep,
  expr = simulate_scenario3(),
  simplify = FALSE
)


# ============================================================
# Extract Complete Case estimates
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

gamma2_cc_values <- vapply(
  simulation_results,
  function(x) x$gamma2_cc,
  numeric(1)
)


# ============================================================
# Extract IPW estimates
# ============================================================

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

gamma2_ipw_values <- vapply(
  simulation_results,
  function(x) x$gamma2_ipw,
  numeric(1)
)


# ============================================================
# Extract Complete Case standard errors
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

se_gamma2_cc_values <- vapply(
  simulation_results,
  function(x) x$se_gamma2_cc,
  numeric(1)
)


# ============================================================
# Extract IPW standard errors
# ============================================================

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

se_gamma2_ipw_values <- vapply(
  simulation_results,
  function(x) x$se_gamma2_ipw,
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

true_gamma0 <- 0.3
true_gamma1 <- -0.8
true_gamma2 <- 0.5


# ============================================================
# Complete Case summary
# ============================================================

summary_cc <- c(
  mean_gamma0 =
    mean(gamma0_cc_values, na.rm = TRUE),

  mean_gamma1 =
    mean(gamma1_cc_values, na.rm = TRUE),

  mean_gamma2 =
    mean(gamma2_cc_values, na.rm = TRUE),

  bias_gamma0 =
    mean(gamma0_cc_values, na.rm = TRUE) - true_gamma0,

  bias_gamma1 =
    mean(gamma1_cc_values, na.rm = TRUE) - true_gamma1,

  bias_gamma2 =
    mean(gamma2_cc_values, na.rm = TRUE) - true_gamma2,

  empirical_sd_gamma0 =
    sd(gamma0_cc_values, na.rm = TRUE),

  empirical_sd_gamma1 =
    sd(gamma1_cc_values, na.rm = TRUE),

  empirical_sd_gamma2 =
    sd(gamma2_cc_values, na.rm = TRUE),

  mean_se_gamma0 =
    mean(se_gamma0_cc_values, na.rm = TRUE),

  mean_se_gamma1 =
    mean(se_gamma1_cc_values, na.rm = TRUE),

  mean_se_gamma2 =
    mean(se_gamma2_cc_values, na.rm = TRUE),

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

  mse_gamma2 =
    mean(
      (gamma2_cc_values - true_gamma2)^2,
      na.rm = TRUE
    ),

  average_missing_rate =
    mean(missing_rates, na.rm = TRUE)
)


# ============================================================
# IPW summary
# ============================================================

summary_ipw <- c(
  mean_gamma0 =
    mean(gamma0_ipw_values, na.rm = TRUE),

  mean_gamma1 =
    mean(gamma1_ipw_values, na.rm = TRUE),

  mean_gamma2 =
    mean(gamma2_ipw_values, na.rm = TRUE),

  bias_gamma0 =
    mean(gamma0_ipw_values, na.rm = TRUE) - true_gamma0,

  bias_gamma1 =
    mean(gamma1_ipw_values, na.rm = TRUE) - true_gamma1,

  bias_gamma2 =
    mean(gamma2_ipw_values, na.rm = TRUE) - true_gamma2,

  empirical_sd_gamma0 =
    sd(gamma0_ipw_values, na.rm = TRUE),

  empirical_sd_gamma1 =
    sd(gamma1_ipw_values, na.rm = TRUE),

  empirical_sd_gamma2 =
    sd(gamma2_ipw_values, na.rm = TRUE),

  mean_se_gamma0 =
    mean(se_gamma0_ipw_values, na.rm = TRUE),

  mean_se_gamma1 =
    mean(se_gamma1_ipw_values, na.rm = TRUE),

  mean_se_gamma2 =
    mean(se_gamma2_ipw_values, na.rm = TRUE),

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

  mse_gamma2 =
    mean(
      (gamma2_ipw_values - true_gamma2)^2,
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
