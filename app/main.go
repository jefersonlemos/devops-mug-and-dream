package main

import (
	"context"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strings"

	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
)

func main() {
	config, err := rest.InClusterConfig()
	if err != nil {
		panic(err.Error())
	}

	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err.Error())
	}

	namespace, err := getCurrentNamespace()
	if err != nil {
		log.Printf("Cannot get current namespace, defaulting to 'default': %v", err)
		namespace = "default"
	}

	podName := os.Getenv("HOSTNAME")
	if podName == "" {
		podName = "unknown"
	}

	pods, err := clientset.CoreV1().Pods(namespace).List(context.TODO(), v1.ListOptions{})
	if err != nil {
		panic(err.Error())
	}

	runningCount := 0
	for _, pod := range pods.Items {
		if pod.Status.Phase == "Running" {
			runningCount++
		}
	}

	fmt.Printf("Namespace: %s\n", namespace)
	fmt.Printf("Instance (Pod) Name: %s\n", podName)
	fmt.Printf("Number of Running Pods in Namespace: %d\n", runningCount)
}

func getCurrentNamespace() (string, error) {
	const nsPath = "/var/run/secrets/kubernetes.io/serviceaccount/namespace"
	data, err := ioutil.ReadFile(nsPath)
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(data)), nil
}
