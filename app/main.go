package main

import (
	"context"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"

	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
)

type PodInfo struct {
	Namespace       string `json:"namespace"`
	InstanceName    string `json:"instanceName"`
	RunningPodCount int    `json:"runningPodCount"`
}

func main() {
	config, err := rest.InClusterConfig()
	if err != nil {
		panic(err.Error())
	}

	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err.Error())
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
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
			http.Error(w, "Failed to list pods: "+err.Error(), http.StatusInternalServerError)
			return
		}

		runningCount := 0
		for _, pod := range pods.Items {
			if pod.Status.Phase == "Running" {
				runningCount++
			}
		}

		info := PodInfo{
			Namespace:       namespace,
			InstanceName:    podName,
			RunningPodCount: runningCount,
		}

		w.Header().Set("Content-Type", "application/json")
		if err := json.NewEncoder(w).Encode(info); err != nil {
			http.Error(w, "Failed to encode JSON: "+err.Error(), http.StatusInternalServerError)
			return
		}
	})

	log.Println("Starting server on :9090")
	log.Fatal(http.ListenAndServe(":9090", nil))
}

func getCurrentNamespace() (string, error) {
	const nsPath = "/var/run/secrets/kubernetes.io/serviceaccount/namespace"
	data, err := ioutil.ReadFile(nsPath)
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(data)), nil
}
