# Liquid Glass Workout Workflow by Edgar

I really enjoyed the take home challenge.

Since the key component is the pill animation, I thought this is an opportunity to implement the control's flow and transformation using the latest apple framework liquid glass. Liquid glass perfectly captures the morphing controls especially the "melting" or "osmosis" properties of the material's edges.

The app is by no means perfect and complete, but the pill animation and transformation using liquid glass is there. I would love to continue and complete the requirements, but I would need more time.
 **Maybe**, this work is enough for you to award me the job.  

I encapsulated the *ExpandableGlassView* which modularises the liquid glass properties of the control.  This is inspired from patreon.com/kavsoft.

## 🧩 Loom Recording
https://www.loom.com/share/db09285db92c42718746c90f0a05e43c

## 🧩 Checklists
1. ✅ Tap `Start` to begin the workout
2. ✅ Enter `Kg` and `Reps` for each set
3. ✅ Tap to complete a set and start a rest timer
4. ✅ Finish all sets to see a summary screen

- ✅ The pill-shaped button at the bottom ("Start") should ****fluidly animate**** to become the keyboard, timer etc (This is important and a key factor we're looking at).
Animate through these states:
- ✅ Start → Timer + Finish
- ✅ Timer → Number Pad
- ✅ Number Pad → Rest Timer Picker
- ✅ Rest Timer Picker → Countdown

As per instruction I built the app using: 
- ✅ SwiftUI 
- ✅ MVVM
- ✅ Dynamic Text Size 
- ✅ Dark and Light mode
