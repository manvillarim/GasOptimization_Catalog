# 21. Avoid Nested Loops

This transformation replaces a doubly nested loop by two sequential loops when the body accumulates a product of one element of each array. The sum of all pairwise products factors as the product of the two sums, so the same result is reached in `n + m` iterations instead of `n * m`.

## Example

### Original (Nested Loops)
```solidity
contract A {
    uint64[] public array1;
    uint64[] public array2;
    uint64 public totalSumOfProducts;

    function calculateSumOfProducts() external {
        uint64 tempSum = 0;
        for (uint256 i = 0; i < array1.length; i++) {
            for (uint256 j = 0; j < array2.length; j++) {
                unchecked {
                    tempSum += array1[i] * array2[j];
                }
            }
        }
        totalSumOfProducts = tempSum;
    }
}
```

### Optimised (Sequential Loops)
```solidity
contract Ao {
    uint64[] public array1;
    uint64[] public array2;
    uint64 public totalSumOfProducts;

    function calculateSumOfProducts() external {
        uint64 sumA = 0;
        for (uint256 i = 0; i < array1.length; i++) {
            unchecked {
                sumA += array1[i];
            }
        }

        uint64 sumB = 0;
        for (uint256 j = 0; j < array2.length; j++) {
            unchecked {
                sumB += array2[j];
            }
        }

        unchecked {
            totalSumOfProducts = sumA * sumB;
        }
    }
}
```

## Applicability

The rewrite rests on distributivity, which holds exactly over machine words but not under Solidity's checked arithmetic, where an intermediate overflow reverts. The two versions overflow on different intermediates: the original on a partial sum of products, the rewrite on `sumA` or on `sumB`. Taking 256-bit elements for the illustration, `array1 = [2**255, 2**255]` and `array2 = [0]` make every product zero, so the original stores zero while the rewrite reverts computing `sumA`.

The transformation therefore requires either that the two sums fit in the width of the accumulator, or that the arithmetic be placed inside an `unchecked` block, where both versions wrap and the identity holds exactly. The contracts above take the second route, which is why every accumulation is `unchecked`.

The element type is `uint64` rather than `uint256` for a reason that belongs to the proof and not to the rule. Discharging this equivalence means proving distributivity over bitvectors, which is nonlinear arithmetic and is decided by bit-blasting the multiplications. At 256 bits the prover does not terminate: we tried it at three unrolling depths and with the SMT timeout raised to 3,000 seconds, and the rule timed out in every attempt. At 64 bits each multiplication is some sixteen times cheaper to blast and the proof goes through. The rule itself is indifferent to the width; only the mechanised check is.

## Verification

The linked run discharges the equivalence for arrays of up to two elements, which is the unrolling depth the conf sets. This is a bound on the check and not on the rule: the identity it rests on holds for any length. Reporting it matters because the published form of this transformation is stated without any bound at all.

## Gas Savings

Replacing `n * m` iterations by `n + m` removes the quadratic term, and the saving grows with the size of the arrays.
