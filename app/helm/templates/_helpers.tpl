{{- define "app.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "go-app.labels" -}}
app.kubernetes.io/name: {{ include "go-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
