# Unit Tests — tf-atom-vpc-endpoint-subnet-association-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose
#
# NOTE: Computed attributes (the association id/arn) are UNKNOWN under a mock
# provider, so assertions target plan-KNOWN values only: the tf-label-derived
# `enabled` flag and the resource instance count.

mock_provider "aws" {}

variables {
  # tf-label identity
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # Module-required inputs (valid-looking sample values)
  vpc_endpoint_id = "vpce-0123456789abcdef0"
  subnet_id       = "subnet-0123456789abcdef0"
}

# ---------------------------------------------------------------------------
# When enabled (default), the module plans exactly one association resource.
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "Module should report enabled == true when enabled is left at its default."
  }

  assert {
    condition     = length(aws_vpc_endpoint_subnet_association.this) == 1
    error_message = "Exactly one aws_vpc_endpoint_subnet_association should be planned when enabled."
  }

  assert {
    condition     = aws_vpc_endpoint_subnet_association.this[0].vpc_endpoint_id == "vpce-0123456789abcdef0"
    error_message = "vpc_endpoint_id input should pass through to the resource unchanged."
  }
}

# ---------------------------------------------------------------------------
# When disabled, the module creates nothing.
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.enabled == false
    error_message = "Module should report enabled == false when enabled = false."
  }

  assert {
    condition     = length(aws_vpc_endpoint_subnet_association.this) == 0
    error_message = "No association resource should be planned when enabled = false."
  }

  assert {
    condition     = output.association_id == ""
    error_message = "association_id should be empty when the module is disabled."
  }
}
