# Caravel User Project

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)

Asynchronous Fibonacci counter

The counter uses two phase dual rail logic. An asynchronous sequential logic circuit does not rely on the assumption that logic values only need to be valid within a window around the clock edge. Instead, the circuit needs to be valid all the time.

Two phase means that data is represented using edges (both a positive and negative edge are equivalent). These edges are called events.
Dual rail means that for each bit, we use two wires, one for 0 and one for 1. An event is sent on only one of these two wires to send a binary digit.

To transfer data between components, we need to know whether the component we are sending data to is ready to accept new data and when the data has been sent.
A component signals it is ready to accept new data by sending an event on its acknowledge signal.
We know that data has been sent once one event is detected on every pair of wires in a bus.

Excellent book about asynchronous design: https://orbit.dtu.dk/en/publications/introduction-to-asynchronous-circuit-design


