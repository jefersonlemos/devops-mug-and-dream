package main

import (
	"encoding/json"
	"fmt"
	"net"
	"net/http"
	"os"
	"time"
)

var startTime = time.Now()

func main() {
	http.HandleFunc("/", rootHandler)
	http.HandleFunc("/health", healthHandler)

	fmt.Println("Starting server on :9090")
	if err := http.ListenAndServe(":9090", nil); err != nil {
		fmt.Println("Server error:", err)
	}
}

func rootHandler(w http.ResponseWriter, r *http.Request) {
	hostname, _ := os.Hostname()
	ip := firstNonLoopbackIP()
	now := time.Now()

	payload := map[string]interface{}{
		"host_name":      hostname,
		"ip":             ip,
		"hour":           now.Format(time.RFC3339),
		"uptime_seconds": int(time.Since(startTime).Seconds()),
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(payload)
}

func healthHandler(w http.ResponseWriter, _ *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("ok"))
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
