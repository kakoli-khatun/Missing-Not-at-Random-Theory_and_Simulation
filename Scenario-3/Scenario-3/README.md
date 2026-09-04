# Scenario 3: Missingness and Outcome Both Depend on X and U

## Overview

Scenario 3 extends the previous settings by allowing the binary latent variable U to affect both the missingness mechanism and the binary outcome Y.

In this scenario, the probability of observation depends on X and U, and the outcome also depends on X and U.

This setting is used to investigate Complete Case (CC) and Inverse Probability Weighting (IPW) estimation under correctly specified and misspecified models.

## Data-Generating Model

The binary covariate X is generated as:

```text
X ~ Bernoulli(p_x)
```

The latent variable U is generated as:

```text
U ~ Bernoulli(p_u)
```

Let R denote the observation indicator.

## Missingness Mechanism

The probability of observation depends on both X and U:

```text
logit P(R = 1 | X, U)
    = beta0 + beta1*X + beta2*U
```

Equivalently,

```text
P(R = 1 | X = x, U = u)
    = exp(beta0 + beta1*x + beta2*u)
      /
      [1 + exp(beta0 + beta1*x + beta2*u)]
```

## Outcome Model

Unlike Scenario 2, the outcome in Scenario 3 also depends on U.

The true outcome model is:

```text
logit P(Y = 1 | X, U)
    = gamma0 + gamma1*X + gamma2*U
```

Equivalently,

```text
P(Y = 1 | X = x, U = u)
    = exp(gamma0 + gamma1*x + gamma2*u)
      /
      [1 + exp(gamma0 + gamma1*x + gamma2*u)]
```

The parameters of interest are gamma0, gamma1, and gamma2.

## Complete Case Analysis

Two outcome-model specifications are considered.

### Correctly Specified Outcome Model

The correctly specified Complete Case analysis includes both X and U in the outcome model.

Define:

```text
mu_i = P(Y_i = 1 | X_i, U_i)
```

The estimating equation is:

```text
Sum [ R_i * (Y_i - mu_i) * Z_i ] = 0
```

where:

```text
Z_i = (1, X_i, U_i)'
```

### Misspecified Outcome Model

To investigate outcome-model misspecification, U is omitted from the fitted outcome model.

The misspecified model is:

```text
logit P(Y = 1 | X)
    = gamma0 + gamma1*X
```

Define:

```text
mu_tilde_i = P(Y_i = 1 | X_i)
```

The corresponding Complete Case estimating equation is:

```text
Sum [ R_i * (Y_i - mu_tilde_i) * Z_i ] = 0
```

where:

```text
Z_i = (1, X_i)'
```

This comparison is used to investigate the effect of omitting U from the outcome model.

## Inverse Probability Weighting

IPW analyses are also considered under correctly specified and misspecified models.

### Correctly Specified IPW Model

The correctly specified observation-probability model includes both X and U:

```text
P(R_i = 1 | X_i, U_i)
```

The estimating equation is:

```text
Sum [
    R_i / P_hat(R_i = 1 | X_i, U_i)
    * (Y_i - mu_i)
    * Z_i
] = 0
```

where:

```text
Z_i = (1, X_i, U_i)'
```

### Misspecified IPW Model

In the misspecified analysis, U is omitted from the observation-probability model.

The weight model is based on:

```text
P(R_i = 1 | X_i)
```

The outcome model may also omit U:

```text
logit P(Y = 1 | X)
    = gamma0 + gamma1*X
```

The corresponding estimating equation is:

```text
Sum [
    R_i / P_hat(R_i = 1 | X_i)
    * (Y_i - mu_tilde_i)
    * Z_i
] = 0
```

where:

```text
Z_i = (1, X_i)'
```

This setting allows the consequences of model misspecification to be investigated when U is involved in both the true missingness mechanism and the true outcome model.

## Theoretical Investigation

The theoretical component investigates the estimating equations and large-sample behavior of the estimators under the different model specifications.

The work includes:

- formulation of Complete Case and IPW estimating equations;
- investigation of population estimating equations;
- consistency and convergence arguments;
- comparison of correctly specified and misspecified outcome models; and
- comparison of correctly specified and misspecified weight models.

Detailed unpublished mathematical derivations are maintained separately from the public repository.

## Monte Carlo Simulation

Monte Carlo simulations are used to investigate the finite-sample performance of the estimators under the different model specifications.

The simulation compares:

- Complete Case analysis with the correctly specified outcome model;
- Complete Case analysis with a misspecified outcome model;
- IPW with the correctly specified model; and
- IPW under model misspecification.

Estimator performance is evaluated using:

- mean parameter estimate;
- bias;
- empirical standard deviation;
- mean squared error (MSE);
- average missingness rate; and
- performance across different sample sizes.

## Implementation

The simulation is implemented in R and includes:

- generation of X;
- generation of U;
- generation of the observation indicator R;
- generation of the binary outcome Y;
- correctly specified Complete Case estimation;
- misspecified Complete Case estimation;
- correctly specified IPW estimation;
- misspecified IPW estimation;
- repeated Monte Carlo simulation; and
- calculation of estimator performance measures.

Fixed random seeds are used where appropriate to support reproducibility.
