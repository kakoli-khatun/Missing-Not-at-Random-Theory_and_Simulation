# Scenario 2: Missingness Depends on X and U, Outcome Depends on X

## Overview

Scenario 2 extends the first setting by introducing an additional binary latent variable U into the missingness mechanism.

In this scenario, the probability of observation depends on both X and U, while the binary outcome Y depends only on X.

This setting is used to investigate the behavior of Complete Case (CC) and Inverse Probability Weighting (IPW) estimators when the missingness mechanism contains an additional latent variable.

It also allows comparison between correctly specified and misspecified IPW weight models.

## Data-Generating Model

The binary covariate X is generated as:

```text
X ~ Bernoulli(p_x)
```

The latent variable U is generated as:

```text
U ~ Bernoulli(p_u)
```

Let R denote the observation indicator, where R = 1 indicates that X is observed.

## Missingness Mechanism

The probability that X is observed depends on both X and U:

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

The outcome depends only on X:

```text
logit P(Y = 1 | X)
    = gamma0 + gamma1*X
```

Equivalently,

```text
P(Y = 1 | X = x)
    = exp(gamma0 + gamma1*x)
      /
      [1 + exp(gamma0 + gamma1*x)]
```

Define:

```text
mu_i = P(Y_i = 1 | X_i)
```

The parameters of interest are gamma0 and gamma1.

Although U affects the missingness mechanism, U does not enter the outcome model in this scenario.

## Complete Case Analysis

Complete Case analysis uses observations for which X is observed.

The estimating equation is:

```text
Sum [ R_i * (Y_i - mu_i) * Z_i ] = 0
```

where:

```text
Z_i = (1, X_i)'
```

Only observations with R_i = 1 contribute to the estimating equation.

The theoretical component investigates the behavior of the Complete Case estimator when the missingness mechanism depends on both X and U, while the outcome depends only on X.

## Inverse Probability Weighting

Two IPW specifications are considered in this scenario.

### Correctly Specified Weight Model

The correctly specified weight model includes both X and U:

```text
P(R_i = 1 | X_i, U_i)
```

The corresponding estimating equation is:

```text
Sum [
    R_i / P_hat(R_i = 1 | X_i, U_i)
    * (Y_i - mu_i)
    * Z_i
] = 0
```

where:

```text
Z_i = (1, X_i)'
```

### Misspecified Weight Model

To investigate model misspecification, U is omitted from the weight model.

The misspecified observation probability is:

```text
P(R_i = 1 | X_i)
```

The corresponding estimating equation is:

```text
Sum [
    R_i / P_hat(R_i = 1 | X_i)
    * (Y_i - mu_i)
    * Z_i
] = 0
```

where:

```text
Z_i = (1, X_i)'
```

This comparison is used to investigate the consequences of omitting U from the observation-probability model.

## Theoretical Investigation

The theoretical component investigates the estimating equations and large-sample behavior of the Complete Case and IPW estimators under this missingness mechanism.

The work includes:

- formulation of the Complete Case and IPW estimating equations;
- investigation of the corresponding population estimating equations;
- consistency and convergence arguments; and
- comparison of correctly specified and misspecified weight models.

Detailed unpublished mathematical derivations are maintained separately from the public repository.

## Monte Carlo Simulation

Monte Carlo simulations are used to evaluate the finite-sample behavior of the estimators.

The simulation compares:

- Complete Case estimation;
- IPW with the correctly specified weight model; and
- IPW with the misspecified weight model.

Estimator performance is evaluated using:

- mean parameter estimate;
- bias;
- empirical standard deviation;
- mean squared error (MSE); and
- average missingness rate.

## Implementation

The simulation is implemented in R and includes:

- generation of X;
- generation of the latent variable U;
- generation of the observation indicator R;
- generation of the binary outcome Y;
- Complete Case estimation;
- correctly specified IPW estimation;
- misspecified IPW estimation;
- repeated Monte Carlo simulation; and
- calculation of estimator performance measures.

Fixed random seeds are used where appropriate to support reproducibility.
