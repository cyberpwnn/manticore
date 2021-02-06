library manticore.math;

import 'dart:math';

Random _rng = Random.secure();

int ms() => DateTime.now().millisecondsSinceEpoch;

/// Scales B by an external range change so that <br/>
/// <br/>
/// BMIN < B < BMAX <br/>
/// AMIN < RESULT < AMAX <br/>
/// So Given rangeScale(0, 20, 0, 10, 5) -> 10 <br/>
/// 0 < 5 < 10 <br/>
/// 0 < ? < 20 <br/>
/// would return 10
double rangeScale(
        double amin, double amax, double bmin, double bmax, double b) =>
    amin + ((amax - amin) * ((b - bmin) / (bmax - bmin)));

/// Get the percent (inverse lerp) from "from" to "to" where "at".
/// If from = 0 and to = 100 and at = 25 then it would return 0.25
double lerpInverse(double from, double to, double at) =>
    rangeScale(0, 1, from, to, at);

/// Clip the number between a min and max value. Same as min(vmax, max(vmin, value))
T clip<T extends num>(T vmin, T vmax, T value) => min(vmax, max(vmin, value));

/// Will return true PERCENT of the time
bool r(double percent) => _rng.nextDouble() < percent;
