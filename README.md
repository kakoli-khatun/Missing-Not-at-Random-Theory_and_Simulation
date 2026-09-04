# Missing-Not-at-Random-Theory_and_Simulation

This repository contains a theoretical and simulation-based investigation of statistical estimation under **Missing Not at Random (MNAR)** mechanisms.

The project focuses on **Complete Case (CC)** and **Inverse Probability Weighting (IPW)** methods under several missing-data settings involving a binary covariate X, a binary outcome Y, an observation indicator R, and an additional binary latent variable U.

The goal is to connect statistical theory with reproducible Monte Carlo simulation and investigate estimator behavior under correctly specified and misspecified models.

## Project Objectives

This study investigates:

- Complete Case estimation under MNAR mechanisms
- Inverse Probability Weighting
- Correctly specified and misspecified weight models
- Correctly specified and misspecified outcome models
- The role of a latent variable in the missingness and outcome mechanisms
- Finite-sample estimator performance
- Large-sample properties of the estimators

The theoretical component includes investigation of estimator consistency and convergence. Detailed unpublished theoretical derivations are maintained separately from this public repository.

---

## Simulation Scenarios

The study consists of three main scenarios of increasing complexity.

### Scenario 1: Missingness and Outcome Depend on X

In Scenario 1, the probability of observation depends only on X, and the outcome also depends only on X.

**Missingness model**

```text
logit P(R = 1 | X) = beta0 + beta1*X
```

**Outcome model**

```text
logit P(Y = 1 | X) = gamma0 + gamma1*X
```

Complete Case and IPW estimators are investigated under this setting.

---

### Scenario 2: Missingness Depends on X and U, Outcome Depends on X

Scenario 2 introduces an additional binary latent variable U into the missingness mechanism.

**Missingness model**

```text
logit P(R = 1 | X, U) = beta0 + beta1*X + beta2*U
```

**Outcome model**

```text
logit P(Y = 1 | X) = gamma0 + gamma1*X
```

This scenario investigates Complete Case estimation and IPW under correctly specified and misspecified weight models.

**Correctly specified IPW model**

```text
P(R = 1 | X, U)
```

**Misspecified IPW model**

```text
P(R = 1 | X)
```

The misspecified model omits U from the observation-probability model. This allows the effect of weight-model misspecification to be investigated.

---

### Scenario 3: Missingness and Outcome Both Depend on X and U

In Scenario 3, both the probability of observation and the outcome depend on X and U.

**Missingness model**

```text
logit P(R = 1 | X, U) = beta0 + beta1*X + beta2*U
```

**Outcome model**

```text
logit P(Y = 1 | X, U) = gamma0 + gamma1*X + gamma2*U
```

This scenario investigates both outcome-model and weight-model misspecification.

For the outcome model, analyses with and without U are considered. For IPW, correctly specified and misspecified observation-probability models are investigated.

---

## Statistical Methods

### Complete Case Analysis

Complete Case analysis uses observations satisfying the required observation condition.

For an outcome model depending on X, the estimating equation can be represented as:

```text
Sum [ R_i * (Y_i - mu_i) * Z_i ] = 0
```

where:

```text
mu_i = P(Y_i = 1 | X_i)

Z_i = (1, X_i)'
```

The theoretical component investigates the large-sample behavior of the Complete Case estimator under the different missingness mechanisms.

### Inverse Probability Weighting

Inverse Probability Weighting adjusts the estimating equation using the probability that an observation is observed.

A general IPW estimating equation can be represented as:

```text
Sum [ (R_i / pi_i) * (Y_i - mu_i) * Z_i ] = 0
```

where `pi_i` represents the observation probability.

The study considers both correctly specified and misspecified weight models to investigate the consequences of model misspecification.

---

## Theoretical Investigation

The Monte Carlo study is accompanied by a theoretical investigation of the estimators.

The theoretical work includes:

- Formulation of estimating equations
- Investigation of population estimating equations
- Consistency and convergence arguments
- Comparison of estimator behavior under different missingness mechanisms
- Investigation of correctly specified and misspecified models

Detailed mathematical derivations are part of ongoing unpublished work and are maintained separately.

The statistical framework necessary to understand the simulation code is documented in this repository.

---

## Monte Carlo Simulation

Monte Carlo simulations are used to investigate the finite-sample performance of the estimators.

For each simulation setting, repeated datasets are generated according to the specified data-generating and missingness mechanisms.

Estimator performance is evaluated using:

- Mean parameter estimate
- Bias
- Empirical standard deviation
- Mean squared error (MSE)
- Average missingness rate
- Performance across different sample sizes

---

## Implementation

The simulation studies are implemented in **R**.

The code includes:

- Data generation
- Generation of missingness indicators
- Complete Case estimation
- IPW estimation
- Correctly specified and misspecified models
- Monte Carlo replication
- Calculation of bias, empirical standard deviation, and MSE

Fixed random seeds are used where appropriate to support reproducibility.

---

## Repository Structure

```text
Missing-Not-at-Random-Theory_and_Simulation/
|
|-- README.md
|
|-- Scenario-1/
|   |-- README.md
|   `-- scenario1_cc_ipw_simulation.R
|
|-- Scenario-2/
|   |-- README.md
|   `-- scenario2_cc_ipw_simulation.R
|
`-- Scenario-3/
    |-- README.md
    `-- scenario3_cc_ipw_simulation.R
```

Each scenario contains a separate README describing the statistical setup and the corresponding R simulation code.

---

## Project Status

**Work in progress**

This repository contains ongoing methodological and simulation research. The public repository presents the statistical framework, computational implementation, and selected simulation results.

Detailed unpublished theoretical derivations are maintained separately and may be added after further development of the research.
