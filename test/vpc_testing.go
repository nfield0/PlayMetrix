// In test/vpc_test.go

package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformVPC(t *testing.T) {
	t.Parallel()

	// Specify the path to the Terraform code that will be tested.
	terraformOptions := &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "C:/Terraform/playmetrix-cloud",
	}

	// Defer the destruction of resources using `terraform destroy`.
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`.
	terraform.InitAndApply(t, terraformOptions)

	// Validate the VPC was created.
	vpcID := terraform.Output(t, terraformOptions, "playmetric-vpc-id")
	assert.NotNil(t, vpcID)
	if assert.NotEmpty(t, vpcID) {
		t.Logf("VPC ID: %s", vpcID)
		t.Logf("Test for VPC creation passed.")
	} else {
		t.Errorf("Test for VPC creation failed.")
	}

	// Validate the subnets were created.
	publicSubnet1ID := terraform.Output(t, terraformOptions, "public-subnet-1-id")
	assert.NotNil(t, publicSubnet1ID)
	if assert.NotEmpty(t, publicSubnet1ID) {
		t.Logf("Public Subnet 1 ID: %s", publicSubnet1ID)
		t.Logf("Test for Public Subnet 1 creation passed.")
	} else {
		t.Errorf("Test for Public Subnet 1 creation failed.")
	}

	publicSubnet2ID := terraform.Output(t, terraformOptions, "public-subnet-2-id")
	assert.NotNil(t, publicSubnet2ID)
	if assert.NotEmpty(t, publicSubnet2ID) {
		t.Logf("Public Subnet 2 ID: %s", publicSubnet2ID)
		t.Logf("Test for Public Subnet 2 creation passed.")
	} else {
		t.Errorf("Test for Public Subnet 2 creation failed.")
	}

	privateSubnet1ID := terraform.Output(t, terraformOptions, "private-subnet-1-id")
	assert.NotNil(t, privateSubnet1ID)
	if assert.NotEmpty(t, privateSubnet1ID) {
		t.Logf("Private Subnet 1 ID: %s", privateSubnet1ID)
		t.Logf("Test for Private Subnet 1 creation passed.")
	} else {
		t.Errorf("Test for Private Subnet 1 creation failed.")
	}

	privateSubnet2ID := terraform.Output(t, terraformOptions, "private-subnet-2-id")
	assert.NotNil(t, privateSubnet2ID)
	if assert.NotEmpty(t, privateSubnet2ID) {
		t.Logf("Private Subnet 2 ID: %s", privateSubnet2ID)
		t.Logf("Test for Private Subnet 2 creation passed.")
	} else {
		t.Errorf("Test for Private Subnet 2 creation failed.")
	}

	// Example: Validate that the VPC CIDR block matches the expected value.
	expectedVPCCIDR := "10.0.0.0/23"
	actualVPCCIDR, err := terraform.OutputE(t, terraformOptions, "vpc-cidr-block")

	if err != nil {
		t.Error("Failed to retrieve VPC CIDR block from Terraform output.")
	} else {
		t.Logf("Expected VPC CIDR block: %s", expectedVPCCIDR)
		t.Logf("Actual VPC CIDR block: %s", actualVPCCIDR)
		assert.Equal(t, expectedVPCCIDR, actualVPCCIDR, "VPC CIDR block mismatch")
		t.Logf("Test for VPC CIDR block passed.")
	}

	// Example: Validate that the public subnet availability zones match the expected values.
	expectedPublicSubnet1AZ := "eu-west-1a"
	actualPublicSubnet1AZ, err := terraform.OutputE(t, terraformOptions, "availability-zone-for-public-subnet-1")

	if err != nil {
		t.Error("Failed to retrieve VPC CIDR block from Terraform output.")
	} else {
		t.Logf("Expected Public Subnet 1 Availability Zone block: %s", expectedPublicSubnet1AZ)
		t.Logf("Actual Public Subnet 1 Availability Zone block: %s", actualPublicSubnet1AZ)
		assert.Equal(t, expectedPublicSubnet1AZ, actualPublicSubnet1AZ, "Public Subnet 1 Availability Zone block mismatch")
		t.Logf("Test for Public Subnet 1 Availability Zone block passed.")
	}

	expectedPublicSubnet2AZ := "eu-west-1b"
	actualPublicSubnet2AZ, err := terraform.OutputE(t, terraformOptions, "availability-zone-for-public-subnet-2")

	if err != nil {
		t.Error("Failed to retrieve VPC CIDR block from Terraform output.")
	} else {
		t.Logf("Expected Public Subnet 2 Availability Zone block: %s", expectedPublicSubnet2AZ)
		t.Logf("Actual Public Subnet 2 Availability Zone block: %s", actualPublicSubnet2AZ)
		assert.Equal(t, expectedPublicSubnet2AZ, actualPublicSubnet2AZ, "Public Subnet 2 Availability Zone block mismatch")
		t.Logf("Test for Public Subnet 2 Availability Zone block passed.")
	}

	// // Example: Validate that the private subnet availability zones match the expected values.
	expectedPrivateSubnet1AZ := "eu-west-1b"
	actualPrivateSubnet1AZ, err := terraform.OutputE(t, terraformOptions, "availability-zone-for-private-subnet-1")

	if err != nil {
		t.Error("Failed to retrieve VPC CIDR block from Terraform output.")
	} else {
		t.Logf("Expected Private Subnet 1 Availability Zone block: %s", expectedPrivateSubnet1AZ)
		t.Logf("Actual Private Subnet 1 Availability Zone block: %s", actualPrivateSubnet1AZ)
		assert.Equal(t, expectedPrivateSubnet1AZ, actualPrivateSubnet1AZ, "Private Subnet 1 Availability Zone block mismatch")
		t.Logf("Test for Private Subnet 1 Availability Zone block passed.")
	}

	expectedPrivateSubnet2AZ := "eu-west-1c"
	actualPrivateSubnet2AZ, err := terraform.OutputE(t, terraformOptions, "availability-zone-for-private-subnet-2")

	if err != nil {
		t.Error("Failed to retrieve VPC CIDR block from Terraform output.")
	} else {
		t.Logf("Expected Private Subnet 2 Availability Zone block: %s", expectedPrivateSubnet2AZ)
		t.Logf("Actual Private Subnet 2 Availability Zone block: %s", actualPrivateSubnet2AZ)
		assert.Equal(t, expectedPrivateSubnet2AZ, actualPrivateSubnet2AZ, "Private Subnet 2 Availability Zone block mismatch")
		t.Logf("Test for Private Subnet 2 Availability Zone block passed.")
	}

}
