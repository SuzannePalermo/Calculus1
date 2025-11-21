import random # Needed for sample, choice, and randint functions
# Assuming the following functions and constants are defined in your environment:
# from your_framework import BaseGenerator, var, Integer, expand, limit, sqrt, pi, sin, cos, choice, shuffle, sample

class Generator(BaseGenerator):
    def data(self):
        x = var("x")
      
        # NOTE: Using random.sample/random.choice for standard Python random methods
        # and assuming 'choice' and 'shuffle' from the framework are similar.
      
        # Rational Function Factored (0/0 case)
        ############################
        ### Generate 3 zeros to use in polynomials
        zeros = random.sample([Integer(i) for i in range(-6, 7) if i != 0], 3)
        ## Construct numerator and denominator with a shared zero
        top1 = expand((x - zeros[0]) * (x - zeros[1]))
        bottom1 = expand((x - zeros[1]) * (x - zeros[2]))
        ## Evaluate the limit at the shared zero
        a1 = zeros[1]
        limf1 = limit(top1 / bottom1, x=a1)


        # Plug in the Number (Direct Substitution for Rational Functions)
        ####################
        ## 2 zeros on top, 2 zeros on bottom, 5th is where we evaluate the limit
        zeros = random.sample([i for i in range(-6, 7) if i != 0], 5)
        ## Construct numerator and denominator, no shared zeros
        top2 = expand((x - zeros[0]) * (x - zeros[1]))
        bottom2 = expand((x - zeros[2]) * (x - zeros[3]))
        ## Evaluate somewhere else
        a2 = zeros[4]
        limf2 = limit(top2 / bottom2, x=a2)

        # Rationalize (0/0 case with radicals)
        #############
        ## Choose some values to use that will make this not terrible
        value = random.choice(range(1, 10))
        square = random.choice(range(1, 7))**2
        ## Create numerator and denominator
        exp1 = sqrt(x + square - value) - sqrt(square)
        exp2 = x - value
        ## Shuffle them
        fraction = [exp1, exp2]
        random.shuffle(fraction)
        ## Construct top and bottom
        top3 = fraction[0]
        bottom3 = fraction[1]
        ## Evaluate at the zero
        a3 = value
        limf3 = limit(top3 / bottom3, x=a3)

        # Common Denominator (0/0 case with complex fractions)
        ####################
        values = random.sample([i for i in range(-6, 7) if i != 0], 2)
        frac = 1 / values[0]
        top4 = 1 / (x - values[1] + values[0]) - frac
        bottom4 = x - values[1]
        a4 = values[1]
        limf4 = limit(top4 / bottom4, x=a4)

        # Trigonometric functions (Direct Substitution)
        ####################
        common_angles = [
            (0, 1), # 0
            (1, 6), # pi/6
            (1, 4), # pi/4
            (1, 3), # pi/3
            (1, 2), # pi/2
            (1, 1), # pi
        ]

        # 1. Choose limit point 'a5' (e.g., pi/4)
        num_a, den_b = random.choice(common_angles)
        a5 = (num_a * pi) / den_b
      
        # 2. Choose coefficients (using random.randint for consistency)
        A = random.randint(1, 3)
        C = random.randint(1, 4)
      
        # 3. Define the simplest continuous limit forms
        limit_forms = [
            # Type 1: A*sin(x) + C
            A * sin(x) + C,
            # Type 2: A*cos(x) - C
            A * cos(x) - C,
            # Type 3: Simple product A*x*sin(x)
            A * x * sin(x),
            # Type 4: Simple Quotient A*cos(x)/(x+C)
            (A * cos(x)) / (x + C),
        ]

        expression = random.choice(limit_forms)
      
        # 4. Deconstruct the expression into top5 and bottom5 (for consistency with the output format)
        top5 = expression
        bottom5 = random.choice([-2,-4,-5,2,3,4,5,6,7])
      
        # If the quotient form was chosen, correctly assign numerator and denominator
        if expression == limit_forms[3]:
            top5 = A * cos(x)
            # Ensure denominator (x + C) does not become zero at a5
            if (a5 + C) == 0:
                C = random.choice([i for i in range(5, 11)]) # Re-randomize C
                expression = (A * cos(x)) / (x + C) # Update expression
                top5 = A * cos(x)
              
            bottom5 = x + C

        # 5. Calculate the limit
        limf5 = limit(expression, x=a5)

                # Problem Type 6: Exponential functions (Direct Substitution)
        ####################
        # Choose coefficients A, B, C for A * exp(B*x) + C
        A_exp = random.randint(1, 4)
        B_exp = random.choice([-2, -1, 1, 2])
        C_exp = random.randint(1, 5)
        
        # Choose a simple limit point a6 (e.g., 0, 1, -1)
        a6 = random.choice([-1, 0, 1, 2])
        
        # Define the expression
        top6 = A_exp * exp(B_exp * x) + C_exp
        bottom6 = random.choice([-2,-4,-5,2,3,4,5,6,7])
        
        # Calculate the limit
        limf6 = limit(top6 / bottom6, x=a6)


        # Problem Type 7: Logarithmic functions (Direct Substitution)
        ####################
        # Choose coefficients A, C, D for A * log(x + C) + D
        A_log = random.randint(1, 4)
        C_log = random.randint(1, 5) # Ensures shift is positive
        D_log = random.randint(1, 5)
        
        # Choose a limit point a7 that makes the argument (x + C) positive and simple (e.g., 1, e, 2)
        # We need (a7 + C_log) > 0. Choose a7 > 1
        a7 = random.choice([2, 3, 4, 5])
        
        # Define the expression
        top7 = A_log * log(x + C_log) + D_log
        bottom7 = random.choice([-2,-4,-5,2,3,4,5,6,7])
        
        # Calculate the limit
        limf7 = limit(top7 / bottom7, x=a7)

        # Define the full set of 7 problems
        full_limits = [
            {"num":top1,"den":bottom1,"a":a1,"limit":limf1}, # 0: Rational Factored (0/0)
            {"num":top2,"den":bottom2,"a":a2,"limit":limf2}, # 1: Plug in Number (Rational)
            {"num":top3,"den":bottom3,"a":a3,"limit":limf3}, # 2: Rationalize (0/0)
            {"num":top4,"den":bottom4,"a":a4,"limit":limf4}, # 3: Common Denominator (0/0)
            {"num":top5,"den":bottom5,"a":a5,"limit":limf5}, # 4: Trig (Direct Sub)
            {"num":top6,"den":bottom6,"a":a6,"limit":limf6}, # 5: Exponential (Direct Sub)
            {"num":top7,"den":bottom7,"a":a7,"limit":limf7}, # 6: Logarithmic (Direct Sub)
        ]

        # NEW LOGIC: Select exactly 4 random, unique problems from the full list of 7
        # random.sample() ensures uniqueness and returns a list of the specified size.
        limits = random.sample(full_limits, 4) 


        # Shuffle the final problems
        # Assuming 'shuffle' is a method from your framework for shuffling a sequence
        shuffle(limits) 

        return {
            "limits": limits,
        }