# Aircraft Mission Performance Simulation

MATLAB simulation toolkit for aircraft mission performance analysis, covering maximum range/endurance optimization and a complete 3-DOF point-mass mission simulator (take-off to landing).

## Context

This project develops a numerical model to predict and optimize the mission performance of a propeller-driven aircraft under different flight strategies, and to simulate a complete UAV mission profile using a simplified 3-DOF point-mass model.

## Task 1 — Mission Performance: Maximum Range & Endurance

### Approach
- The optimal lift coefficient for **maximum range** is obtained analytically by maximizing the lift-to-drag ratio (CL/CD), using the adjusted drag polar model.
- The optimal lift coefficient for **maximum endurance** is obtained by a numerical search over the admissible angle-of-attack range (0°–15°), maximizing CL^(3/2)/CD.
- Two flight strategies are simulated for each case: **constant true airspeed** (aircraft climbs as weight decreases) and **constant altitude** (airspeed decreases as weight decreases).
- Aircraft mass, drag, required power, fuel flow and altitude/velocity are updated at each time step until the fuel reserve reaches 100 L, per the mission requirement.
- The ISA atmosphere model is used throughout for air density and altitude conversion.

### Results

| Case | Flight time | Distance / Range |
|---|---|---|
| Max range — constant velocity | 202,960 s (~56 h) | 1.385×10⁷ m |
| Max range — constant altitude | 226,655 s | 1.385×10⁷ m |
| Max endurance — constant velocity | 210,880 s | 1.940×10⁷ m |
| Max endurance — constant altitude | 235,500 s | 9.397×10⁶ m |

Optimum lift coefficients: **CL_range = 0.807** (α ≈ 4.1°), **CL_endurance ≈ 1.89** (α = 15°, at the stall boundary of the provided aerodynamic model).

**Key finding**: maximizing endurance drives the aircraft toward a higher lift coefficient and lower cruise speed than maximizing range, consistent with the Breguet range/endurance theory. The endurance optimum coincided with the stall angle predicted by the linear aerodynamic model — in practice, a safety margin below stall would be enforced.

## Task 2 — Full Mission Simulation (3-DOF, Take-off to Landing)

A complete 7-phase mission is simulated using a 3-DOF point-mass model (position, velocity, altitude — rotational dynamics neglected):

1. **Take-off** — throttle ramp-up to rotation speed
2. **Climb** — constant target airspeed (70 m/s), fixed flight path angle (γ = 8°), until 20,000 ft
3. **Cruise (outbound)** — level flight at constant airspeed until the target range
4. **Loiter** — one full circular orbit at constant altitude/airspeed, 10° bank angle
5. **Cruise (return)** — same as outbound cruise
6. **Descent** — γ = -3° until ground level
7. **Landing** — deceleration to touchdown

### Throttle control — numerical search instead of PID
Rather than a classical feedback controller, throttle is determined at each time step by sweeping 1000 candidate throttle values (0–100%), predicting the resulting velocity for each, and selecting the throttle that minimizes the error to the target airspeed. This avoids manual controller tuning while reliably tracking the target airspeed throughout all mission phases.

## Assumptions

- Steady, wings-level cruise flight; pitching moment equilibrium neglected (trimmed aircraft assumed)
- ISA atmosphere (ΔISA = 0°C)
- Adjusted drag polar model: CD = CDmin + K·(CL − CL_at_CDmin)²
- Lift equals weight (L=W) and thrust equals drag (T=D) at every time step for Task 1
- Constant propeller efficiency and specific fuel consumption
- Fuel consumption is the only source of mass variation
- Wind, turbulence, compressibility effects and engine performance degradation with altitude are neglected

## Usage

```matlab
% Run in MATLAB
mission_performance_simulation
```

The script is organized in `%%`-delimited sections (runnable as MATLAB "cells"): Task 1.A (range, constant velocity / constant altitude), Task 1.B (endurance, constant velocity / constant altitude), and Task 2 (full 7-phase mission). Each section generates its own plots (aircraft mass, altitude/velocity, range, fuel remaining vs. time).

## Requirements

- MATLAB (no additional toolboxes required)

## Author

Yasin Ozbay — Aerospace Engineer ([LinkedIn](#) / [email](mailto:Ozbay.yasinahmet@gmail.com))
