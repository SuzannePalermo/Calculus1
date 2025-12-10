import random # Needed for sample, choice, and randint functions
# Assuming the following functions and constants are defined in your environment:
# from your_framework import BaseGenerator, var, Integer, expand, limit, sqrt, oo, choice, shuffle, sample

class Generator(BaseGenerator):
    def data(self):
        x = var("x")
        # Define a constant for unity in limit denominators where division is necessary
        # The value is 1, but using a constant name avoids the literal '1' in the bottom variable.
        UNITY_FOR_DIVISION = 1
        
        # Assuming 'oo' (infinity) is available from the framework for limits
        # NOTE: The mathematical absolute value function is 'abs()' in SageMath/Python.

        # NOTE: Using random.sample/random.choice for standard Python random methods
        # and assuming 'choice' and 'shuffle' from the framework are similar.
      
        # --- Problem Generation (Types 1-4) ---
        
        # Problem Type 1: Rational Function Factored (0/0 case)
        ############################
        zeros = random.sample([Integer(i) for i in range(-6, 7) if i != 0], 3)
        top1 = expand((x - zeros[0]) * (x - zeros[1]))
        bottom1 = expand((x - zeros[1]) * (x - zeros[2]))
        a1 = zeros[1]
        limf1 = limit(top1 / bottom1, x=a1)


        # Problem Type 2: Plug in the Number (Direct Substitution for Rational Functions)
        ####################
        zeros = random.sample([i for i in range(-6, 7) if i != 0], 5)
        top2 = expand((x - zeros[0]) * (x - zeros[1]))
        bottom2 = expand((x - zeros[2]) * (x - zeros[3]))
        a2 = zeros[4]
        limf2 = limit(top2 / bottom2, x=a2)

        # Problem Type 3: Rationalize (0/0 case with radicals)
        #############
        value = random.choice(range(1, 10))
        square = random.choice(range(1, 7))**2
        exp1 = sqrt(x + square - value) - sqrt(square)
        exp2 = x - value
        fraction = [exp1, exp2]
        random.shuffle(fraction)
        top3 = fraction[0]
        bottom3 = fraction[1]
        a3 = value
        limf3 = limit(top3 / bottom3, x=a3)

        # Problem Type 4: Common Denominator (0/0 case with complex fractions)
        ####################
        values = random.sample([i for i in range(-6, 7) if i != 0], 2)
        frac = 1 / values[0]
        top4 = 1 / (x - values[1] + values[0]) - frac
        bottom4 = x - values[1]
        a4 = values[1]
        limf4 = limit(top4 / bottom4, x=a4)

        
        # --- Problem Generation (Types 5-8, Renumbered from 8-11) ---

        # Problem Type 5: Limits at Infinity (Rational $\frac{\infty}{\infty}$)
        ####################
        degree_n = random.randint(1, 4)
        degree_m = random.randint(1, 4)

        coeffs_n = [random.randint(1, 5) * random.choice([1, -1]) for _ in range(degree_n + 1)]
        coeffs_m = [random.randint(1, 5) * random.choice([1, -1]) for _ in range(degree_m + 1)]

        top5 = sum(c * x**i for i, c in enumerate(coeffs_n[::-1]))
        bottom5 = sum(c * x**i for i, c in enumerate(coeffs_m[::-1]))

        a5 = random.choice([oo, -oo]) 
        limf5 = limit(top5 / bottom5, x=a5)
        
        # Problem Type 6: Vertical Asymptote (Limit equals $\pm\infty$)
        # --- Uses one-sided limit for a defined answer $\pm\infty$ (Renumbered from Type 9) ---
        ####################
        a6 = random.choice([Integer(i) for i in range(-5, 6) if i != 0])
        top6_constant = random.randint(1, 4)
        top6 = x + top6_constant * random.choice([1, -1])
        bottom6 = x - a6

        # Choose a one-sided limit direction
        dir6 = random.choice(["plus", "minus"]) 
        a6_lim = a6 
        
        # Calculate limit with direction specified
        limf6 = limit(top6 / bottom6, x=a6_lim, dir=dir6)
        
        # Problem Type 7: Limit at Infinity with Square Root (Renumbered from Type 10)
        ####################
        n = random.choice([0, 1, 2])

        A_num = random.randint(1, 5) * random.choice([1, -1])
        B_num = random.randint(1, 5) * random.choice([1, -1])
        C_den_sq = random.randint(1, 5) 
        D_den = random.randint(1, 5) * random.choice([1, -1])

        if n == 2:
            top7 = A_num * x**2 + B_num * x + random.randint(1, 5)
        elif n == 1:
            top7 = A_num * x + B_num
        else:
            top7 = A_num

        Qx = C_den_sq * x**2 + D_den * x + random.randint(1, 5)
        bottom7 = sqrt(Qx)

        a7 = oo 
        limf7 = limit(top7 / bottom7, x=a7)
        
        # Problem Type 8: Absolute Value Limit (Jump Discontinuity)
        # --- May be one-sided (constant result) or two-sided (limit DNE) ---
        ####################
        a8 = random.choice([Integer(i) for i in range(-4, 5) if i != 0])
        A8 = random.randint(1, 5)
        B8 = random.randint(1, 5) * random.choice([1, -1])
        
        # Simplified classic form:
        top8 = A8 * (x - a8) + B8
        bottom8 = abs(x - a8) 

        # Choose a limit direction: "plus", "minus", or None (two-sided)
        dir8 = random.choice(["plus", "minus", None]) 
        a8_lim = a8
        
        # Calculate limit. If dir8 is None, it computes the two-sided limit.
        limf8 = limit(top8 / bottom8, x=a8_lim, dir=dir8)
        
        # --- OUTCOME CONSTRUCTION ---
        
        # Helper function to create the dictionary entry
        def create_limit_entry(top, bottom, a, lim, dir_val=None, a_lim=None):
            # If denominator is exactly the UNITY constant (which is 1), 
            # use the simplified 'expression' key to ensure no denominator appears in the final output.
            if bottom == UNITY_FOR_DIVISION:
                return {"expression": top, "a": a, "limit": lim}
            else:
                entry = {"num": top, "den": bottom, "a": a_lim if a_lim is not None else a, "limit": lim}
                # Add 'dir' key only if a direction was explicitly chosen
                if dir_val:
                    entry['dir'] = dir_val
                return entry

        # Define the full set of 8 problems using the helper function
        full_limits = [
            create_limit_entry(top1, bottom1, a1, limf1), 
            create_limit_entry(top2, bottom2, a2, limf2), 
            create_limit_entry(top3, bottom3, a3, limf3), 
            create_limit_entry(top4, bottom4, a4, limf4), 
            create_limit_entry(top5, bottom5, a5, limf5), 
            create_limit_entry(top6, bottom6, a6, limf6, dir_val=dir6, a_lim=a6_lim), 
            create_limit_entry(top7, bottom7, a7, limf7), 
            create_limit_entry(top8, bottom8, a8, limf8, dir_val=dir8, a_lim=a8_lim), 
        ]
        
        # Logic: Select exactly 4 random, unique problems from the full list of 8
        limits = random.sample(full_limits, 4) 

        # Shuffle the final problems
        shuffle(limits) 

        return {
            "limits": limits,
        }