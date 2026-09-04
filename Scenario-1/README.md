# Scenario 1: Missingness and Outcome Depend on X

## Overview

Scenario 1 considers the basic setting in which both the probability of
observation and the binary outcome depend on the covariate X.

This scenario serves as a baseline for investigating the theoretical and
finite-sample behavior of Complete Case (CC) and Inverse Probability
Weighting (IPW) estimators.

## Data-Generating Model

The binary covariate X is generated as:

```text
X ~ Bernoulli(p_x)
```

Let R denote the observation indicator, where R = 1 indicates that X is
observed.

## Missingness Mechanism

The probability that X is observed depends on X:

```text
logit P(R = 1 | X) = beta0 + beta1*X
```

Equivalently,

```text
P(R = 1 | X = x)
    = exp(beta0 + beta1*x) /
      [1 + exp(beta0 + beta1*x)]
```

## Outcome Model

The binary outcome Y also depends on X:

```text
logit P(Y = 1 | X) = gamma0 + gamma1*X
```

Equivalently,

```text
P(Y = 1 | X = x)
    = exp(gamma0 + gamma1*x) /
      [1 + exp(gamma0 + gamma1*x)]
```

Define:

```text
mu_i = P(Y_i = 1 | X_i)
```

The parameters of interest are gamma0 and gamma1.

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

The theoretical component of this study investigates the large-sample
behavior and consistency of the Complete Case estimator under this
missingness mechanism.

## Inverse Probability Weighting

Inverse Probability Weighting accounts for the observation mechanism by
weighting observed cases by the inverse of their probability of being
observed.

For the correctly specified weight model, the observation probability is:

```text
P(R_i = 1 | X_i)
```

and the IPW estimating equation is:

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

## Theoretical Investigation

The theoretical component investigates the estimating equations and
large-sample properties of the Complete Case and IPW estimators.

The work includes:

- formulation of the estimating equations;
- investigation of the corresponding population estimating equations;
- consistency and convergence arguments; and
- comparison of the theoretical behavior of CC and IPW.

Detailed unpublished mathematical derivations are maintained separately
from the public repository.

## Monte Carlo Simulation

Monte Carlo simulations are used to examine the finite-sample behavior of
the estimators under the specified missingness mechanism.

Estimator performance is evaluated using:

- mean parameter estimate;
- bias;
- empirical standard deviation;
- mean squared error (MSE); and
- average missingness rate.

## Implementation

The simulation is implemented in R and includes:

- generation of the binary covariate X;
- generation of the observation indicator R;
- generation of the binary outcome Y;
- Complete Case estimation;
- IPW estimation;
- repeated Monte Carlo simulation; and
- calculation of estimator performance measures.

Fixed random seeds are used where appropriate to support reproducibility.


The `simulation/` directory contains the R code for the Complete Case and
IPW analyses.

The `results/` directory contains selected numerical summaries from the
Monte Carlo experiments.
