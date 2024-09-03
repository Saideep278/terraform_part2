package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformHelloWorldExample(t *testing.T) {
	// website::tag::2:: Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// website::tag::1:: Set the path to the Terraform code that will be tested.
		TerraformDir: "./",
	})

	// website::tag::5:: Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::3:: Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)
	// run terraform out to get the ip of the instance
	publicIp :=terraform.Output(t,terraformOptions,"publicp")
	url := fmt.Sprintf("http://%s:8080",publicIp)
	http_helper.HttpGetWithRetry(t,url,nil,200,"Helloworld",30,5*timeSecond)
	// it will make an http required to the instance and make sure that we get 200 ok with the body hello world
	// website::tag::4:: Run `terraform output` to get the values of output variables and check they have the expected values.
	output := terraform.Output(t, terraformOptions, "Helloworld")
	assert.Equal(t, "Helloworld", output)
}