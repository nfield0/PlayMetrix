// In test/rds_test.go

package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformDataBase(t *testing.T) {
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

	// Validate the RDS instance was created.
	rdsInstanceClass := terraform.Output(t, terraformOptions, "DB-instance-class")
	assert.NotNil(t, rdsInstanceClass)
	if assert.NotEmpty(t, rdsInstanceClass) {
		t.Logf("RDS Instance Class: %s", rdsInstanceClass)
		t.Logf("Test for RDS Instance creation passed.")
	} else {
		t.Errorf("Test for RDS Instance creation failed.")
	}

	// test if rds instance class is db.t3.micro
	expectedRDSInstanceClass := "db.t3.micro"
	actualRDSInstanceClass, err := terraform.OutputE(t, terraformOptions, "DB-instance-class")

	if err != nil {
		t.Error("Failed to retrieve RDS Instance Class from Terraform output.")
	} else {
		t.Logf("Expected RDS Instance Class: %s", expectedRDSInstanceClass)
		t.Logf("Actual RDS Instance Class: %s", actualRDSInstanceClass)
		assert.Equal(t, expectedRDSInstanceClass, actualRDSInstanceClass, "RDS Instance Class mismatch")
		t.Logf("Test for RDS Instance Class passed.")
	}

	// validate the RDS instance is in the correct subnet
	expectedRDSSubnet := "playmetric-db-subnet-group"
	actualRDSSubnet, err := terraform.OutputE(t, terraformOptions, "DB-subnet-group-name")

	if err != nil {
		t.Error("Failed to retrieve RDS Subnet Group from Terraform output.")
	} else {
		t.Logf("Expected RDS Subnet Group: %s", expectedRDSSubnet)
		t.Logf("Actual RDS Subnet Group: %s", actualRDSSubnet)
		assert.Equal(t, expectedRDSSubnet, actualRDSSubnet, "RDS Subnet Group mismatch")
		t.Logf("Test for RDS Subnet Group passed.")
	}

	// validate the RDS port is 3306
	expectedRDSPort := "5432"
	actualRDSPort, err := terraform.OutputE(t, terraformOptions, "DB-port")

	if err != nil {
		t.Error("Failed to retrieve RDS Port from Terraform output.")
	} else {
		t.Logf("Expected RDS Port: %s", expectedRDSPort)
		t.Logf("Actual RDS Port: %s", actualRDSPort)
		assert.Equal(t, expectedRDSPort, actualRDSPort, "RDS Port mismatch")
		t.Logf("Test for RDS Port passed.")
	}

	// validate the RDS engine is postgres
	expectedRDSEngine := "postgres"
	actualRDSEngine, err := terraform.OutputE(t, terraformOptions, "DB-engine")

	if err != nil {
		t.Error("Failed to retrieve RDS Engine from Terraform output.")
	} else {
		t.Logf("Expected RDS Engine: %s", expectedRDSEngine)
		t.Logf("Actual RDS Engine: %s", actualRDSEngine)
		assert.Equal(t, expectedRDSEngine, actualRDSEngine, "RDS Engine mismatch")
		t.Logf("Test for RDS Engine passed.")
	}

	// validate the RDS username
	expectedRDSUsername := "DBAdmin"
	actualRDSUsername, err := terraform.OutputE(t, terraformOptions, "DB-username")

	if err != nil {
		t.Error("Failed to retrieve RDS Username from Terraform output.")
	} else {
		t.Logf("Expected RDS Username: %s", expectedRDSUsername)
		t.Logf("Actual RDS Username: %s", actualRDSUsername)
		assert.Equal(t, expectedRDSUsername, actualRDSUsername, "RDS Username mismatch")
		t.Logf("Test for RDS Username passed.")
	}
}
