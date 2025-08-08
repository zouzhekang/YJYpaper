#!/usr/bin/env python3
"""
Data Validation Script for Domestic Violence Statistics
Ensures mathematical consistency of weighted averages in statistical tables
"""

def validate_weighted_average(urban_rate, rural_rate, urban_weight, rural_weight, claimed_total):
    """
    Validates that the total rate is a mathematically correct weighted average
    
    Args:
        urban_rate (float): Urban domestic violence rate (%)
        rural_rate (float): Rural domestic violence rate (%)
        urban_weight (float): Urban population proportion (0-1)
        rural_weight (float): Rural population proportion (0-1)
        claimed_total (float): Claimed overall rate (%)
    
    Returns:
        dict: Validation results
    """
    # Calculate correct weighted average
    correct_total = urban_rate * urban_weight + rural_rate * rural_weight
    
    # Check if weights sum to 1
    weights_sum = urban_weight + rural_weight
    weights_valid = abs(weights_sum - 1.0) < 0.001
    
    # Check if claimed total matches calculated total
    total_valid = abs(claimed_total - correct_total) < 0.1
    
    return {
        'weights_valid': weights_valid,
        'weights_sum': weights_sum,
        'correct_total': correct_total,
        'claimed_total': claimed_total,
        'difference': abs(claimed_total - correct_total),
        'total_valid': total_valid,
        'is_consistent': weights_valid and total_valid
    }

def main():
    """Main validation function"""
    print("=== Domestic Violence Statistics Validation ===\n")
    
    # Table 5.1 data (corrected version)
    urban_rate = 23.7
    rural_rate = 31.2
    urban_samples = 5230
    rural_samples = 5287
    total_samples = urban_samples + rural_samples
    
    urban_weight = urban_samples / total_samples
    rural_weight = rural_samples / total_samples
    
    # Test the corrected data
    corrected_total = 27.5
    
    print("Testing CORRECTED Table 5.1 data:")
    print(f"Urban rate: {urban_rate}%")
    print(f"Rural rate: {rural_rate}%")
    print(f"Urban weight: {urban_weight:.3f} ({urban_weight*100:.1f}%)")
    print(f"Rural weight: {rural_weight:.3f} ({rural_weight*100:.1f}%)")
    print(f"Claimed total: {corrected_total}%")
    
    result = validate_weighted_average(urban_rate, rural_rate, urban_weight, rural_weight, corrected_total)
    
    print(f"\nValidation Results:")
    print(f"Weights sum to 1.0: {result['weights_valid']} (sum = {result['weights_sum']:.3f})")
    print(f"Calculated total: {result['correct_total']:.1f}%")
    print(f"Difference from claimed: {result['difference']:.1f} percentage points")
    print(f"Total is valid: {result['total_valid']}")
    print(f"Overall consistency: {'✓ PASS' if result['is_consistent'] else '✗ FAIL'}")
    
    # Test the problematic data mentioned in the issue
    print("\n" + "="*50)
    print("Testing PROBLEMATIC data mentioned in issue:")
    problematic_total = 28.4
    
    print(f"Urban rate: {urban_rate}%")
    print(f"Rural rate: {rural_rate}%")
    print(f"Urban weight: {urban_weight:.3f} ({urban_weight*100:.1f}%)")
    print(f"Rural weight: {rural_weight:.3f} ({rural_weight*100:.1f}%)")
    print(f"Claimed total: {problematic_total}%")
    
    result2 = validate_weighted_average(urban_rate, rural_rate, urban_weight, rural_weight, problematic_total)
    
    print(f"\nValidation Results:")
    print(f"Weights sum to 1.0: {result2['weights_valid']} (sum = {result2['weights_sum']:.3f})")
    print(f"Calculated total: {result2['correct_total']:.1f}%")
    print(f"Difference from claimed: {result2['difference']:.1f} percentage points")
    print(f"Total is valid: {result2['total_valid']}")
    print(f"Overall consistency: {'✓ PASS' if result2['is_consistent'] else '✗ FAIL'}")
    
    if not result2['is_consistent']:
        print(f"\n⚠️  WARNING: The original claimed total of {problematic_total}% violates")
        print(f"   mathematical consistency by {result2['difference']:.1f} percentage points!")

if __name__ == "__main__":
    main()