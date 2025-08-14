package main

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"net"
	"net/http"
	"os"
	"runtime"
	"strconv"
	"time"
)

var startTime = time.Now()

func main() {
	http.HandleFunc("/", rootHandler)
	http.HandleFunc("/healthz", healthHandler)

	fmt.Println("Starting server on :8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		fmt.Println("Server error:", err)
	}
}

func rootHandler(w http.ResponseWriter, r *http.Request) {
	hostname, _ := os.Hostname()
	ip := firstNonLoopbackIP()
	now := time.Now()

	payload := map[string]interface{}{
		"host":           hostname,
		"ip":             ip,
		"hora":           now.Format(time.RFC3339),
		"namespace":      os.Getenv("POD_NAMESPACE"),
		"pod_name":       os.Getenv("POD_NAME"),
		"uptime_seconds": int(time.Since(startTime).Seconds()),
		"go_version":     runtime.Version(),
		"request_id":     genReqID(),
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(payload)
}

func healthHandler(w http.ResponseWriter, _ *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("ok"))
}

func genReqID() string {
	return strconv.FormatInt(time.Now().UnixNano(), 36) + "-" + strconv.FormatInt(rand.Int63(), 36)
}

func firstNonLoopbackIP() string {
	ifaces, _ := net.Interfaces()
	for _, iface := range ifaces {
		if iface.Flags&net.FlagUp == 0 || iface.Flags&net.FlagLoopback != 0 {
			continue
		}
		addrs, _ := iface.Addrs()
		for _, a := range addrs {
			var ip net.IP
			switch v := a.(type) {
			case *net.IPNet:
				ip = v.IP
			case *net.IPAddr:
				ip = v.IP
			}
			if ip == nil || ip.IsLoopback() {
				continue
			}
			ip = ip.To4()
			if ip == nil {
				continue
			}
			return ip.String()
		}
	}
	return ""
}
