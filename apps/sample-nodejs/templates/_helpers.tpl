{{/* Release name prefix avoids resource name collisions between multiple installs of this chart (e.g. staging/prod). */}}
{{- define "sample-nodejs.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end -}}

{{/* Shared label set, included via nindent in every resource so all four templates stay in sync by construction. */}}
{{- define "sample-nodejs.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end -}}
