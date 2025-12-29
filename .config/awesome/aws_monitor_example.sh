#!/bin/bash

STACK_ID="$1"

# Check if stack ID is provided
if [ -z "$STACK_ID" ]; then
    echo "0"
    exit 0
fi

# Query AWS CloudFormation for stack events or status
# This could be checking for:
# - Number of failed resources
# - Number of stacks in error state
# - Number of drift detected items
# - Number of UPDATE_ROLLBACK or other warning states

# Example 1: Count stacks in failed/rollback states
aws cloudformation describe-stacks \
    --stack-name "$STACK_ID" \
    --query 'Stacks[?StackStatus==`ROLLBACK_COMPLETE` || StackStatus==`UPDATE_ROLLBACK_COMPLETE` || StackStatus==`CREATE_FAILED`] | length(@)' \
    --output text 2>/dev/null || echo "0"

# Example 2: Count failed resources in a stack
# aws cloudformation describe-stack-resources \
#     --stack-name "$STACK_ID" \
#     --query 'StackResources[?ResourceStatus==`CREATE_FAILED` || ResourceStatus==`UPDATE_FAILED`] | length(@)' \
#     --output text 2>/dev/null || echo "0"

# Example 3: Check drift detection results
# aws cloudformation describe-stack-resource-drifts \
#     --stack-name "$STACK_ID" \
#     --query 'StackResourceDrifts[?StackResourceDriftStatus==`MODIFIED` || StackResourceDriftStatus==`DELETED`] | length(@)' \
#     --output text 2>/dev/null || echo "0"
