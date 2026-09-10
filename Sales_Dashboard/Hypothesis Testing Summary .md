# Hypothesis Testing Summary — Sales Performance FY2025

**Dataset:** `Sales_Cleaned_Data.csv` (992 orders, 941 customers, 6 products, 5 categories, 8 cities)
**Purpose:** Statistically validate two claims surfaced during exploratory analysis before they go into the stakeholder narrative.

---

## Test 1 — Does Electronics earn a higher average order value?

**Business question:** Electronics is the top-revenue category (₹50.6M, 37% of total). Is that because each Electronics order is worth more, or simply because there are more of them?

| | |
|---|---|
| **Test** | Welch's two-sample t-test (unequal variances) |
| **H₀** | Mean order value is equal for Electronics and non-Electronics orders |
| **H₁** | Mean order value differs between the two groups |
| **Groups** | Electronics (n = 352, mean = ₹143,758) vs. all other categories (n = 640, mean = ₹136,721) |
| **t-statistic** | 0.916 |
| **p-value** | 0.3599 |
| **Mean difference** | ₹7,037 |
| **95% CI of difference** | −₹8,045 to ₹22,120 |
| **Effect size (Cohen's d)** | 0.062 (negligible) |

**Result:** Fail to reject H₀. The difference is not statistically significant (p = 0.36, well above α = 0.05), and the 95% confidence interval spans zero — the true difference could just as easily be negative as positive.

**Business conclusion:** Electronics' revenue lead is a **volume story, not a pricing story**. It sells at essentially the same average order value as every other category; it wins on total revenue purely because it's ordered more often. Recommendation: marketing and inventory planning for Electronics should optimize for reach and frequency, not for upselling to a higher basket size.

---

## Test 2 — Is category preference associated with gender?

**Business question:** Does what customers buy differ by gender, or is category choice essentially gender-neutral?

| | |
|---|---|
| **Test** | Chi-squared test of independence |
| **H₀** | Product category is independent of gender |
| **H₁** | Product category is associated with gender |
| **Contingency table (orders)** | Education: M 80 / F 96 · Electronics: M 194 / F 158 · Fashion: M 67 / F 89 · Furniture: M 84 / F 74 · Grocery: M 80 / F 70 |
| **Chi-squared statistic** | 9.215 |
| **Degrees of freedom** | 4 |
| **p-value** | 0.0559 |
| **Effect size (Cramer's V)** | 0.096 (small) |

**Result:** Fail to reject H₀ at the conventional 5% threshold — but only barely (p = 0.056). This is a **borderline** result: not significant, but close enough that it shouldn't be dismissed outright. The largest deviation from what independence would predict is in Electronics, where male orders (194) run above the expected count (~179) and female orders (158) run below it (~173).

**Business conclusion:** There is **not enough evidence today** to justify building gender-targeted category marketing — the association could plausibly be due to chance. However, the borderline p-value and the visible skew in Electronics make this worth **re-testing on a larger sample** (e.g., after another quarter of orders) or validating with a small, low-cost A/B test before committing marketing spend to a gender-based segmentation strategy.

---

## How these findings shape the narrative

Both tests corrected an assumption the raw revenue numbers alone would have suggested:

- Without testing, "Electronics generates the most revenue" could easily be misread as "Electronics customers spend more per order." The t-test shows that's false — it's a volume effect.
- Without testing, the modest gender skew in category mix (more male Electronics orders, more female Fashion/Education orders) could be over-interpreted as a real behavioral pattern. The chi-squared test shows it's not yet statistically distinguishable from noise, though it's worth watching.

This is the value of the statistical validation step: it stops two plausible-sounding but unsupported claims from reaching stakeholders, while flagging one of them as worth a follow-up test rather than closing the door completely.

---

## Reproducing this analysis

```python
import pandas as pd
from scipy import stats

df = pd.read_csv("Sales_Cleaned_Data.csv")

# Test 1: Welch's t-test
electronics = df[df["Category"] == "Electronics"]["Total_Sales"]
other = df[df["Category"] != "Electronics"]["Total_Sales"]
t_stat, p_val = stats.ttest_ind(electronics, other, equal_var=False)

# Test 2: Chi-squared test of independence
contingency = pd.crosstab(df["Gender"], df["Category"])
chi2, p_chi, dof, expected = stats.chi2_contingency(contingency)
```
