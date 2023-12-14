// In test/alb_test.go

package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformALB(t *testing.T) {
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

	albDNSName := terraform.Output(t, terraformOptions, "web-app-alb-dns-name")
	assert.NotNil(t, albDNSName)
	if assert.NotEmpty(t, albDNSName) {
		t.Logf("ALB DNS Name: %s", albDNSName)
		t.Logf("Test for ALB creation passed.")
	} else {
		t.Errorf("Test for ALB creation failed.")
	}

	// test is alb zone id is correct
	expectedAlbZoneID := "Z32O12XQLNTSW2"
	actualAlbZoneID, err := terraform.OutputE(t, terraformOptions, "web-app-alb-zone-id")

	if err != nil {
		t.Error("Failed to retrieve ALB Zone ID from Terraform output.")
	} else {
		t.Logf("Expected ALB Zone ID: %s", expectedAlbZoneID)
		t.Logf("Actual ALB Zone ID: %s", actualAlbZoneID)
		assert.Equal(t, expectedAlbZoneID, actualAlbZoneID, "ALB Zone ID mismatch")
		t.Logf("Test for ALB Zone ID passed.")
	}

	// test if alb port is correct
	expectedAlbPort := "80"
	actualAlbPort, err := terraform.OutputE(t, terraformOptions, "web-app-alb-port")

	if err != nil {
		t.Error("Failed to retrieve ALB Port from Terraform output.")
	} else {
		t.Logf("Expected ALB Port: %s", expectedAlbPort)
		t.Logf("Actual ALB Port: %s", actualAlbPort)
		assert.Equal(t, expectedAlbPort, actualAlbPort, "ALB Port mismatch")
		t.Logf("Test for ALB Port passed.")
	}

	// test if alb protocol is correct
	expectedAlbProtocol := "HTTP"
	actualAlbProtocol, err := terraform.OutputE(t, terraformOptions, "web-app-alb-protocol")

	if err != nil {
		t.Error("Failed to retrieve ALB Protocol from Terraform output.")
	} else {
		t.Logf("Expected ALB Protocol: %s", expectedAlbProtocol)
		t.Logf("Actual ALB Protocol: %s", actualAlbProtocol)
		assert.Equal(t, expectedAlbProtocol, actualAlbProtocol, "ALB Protocol mismatch")
		t.Logf("Test for ALB Protocol passed.")
	}

}
