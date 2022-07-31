{{/*
Expand the name of the chart.
*/}}
{{- define "pi-hole.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pi-hole.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pi-hole.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "pi-hole.labels" -}}
helm.sh/chart: {{ include "pi-hole.chart" . }}
{{ include "pi-hole.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: Yggio
{{- end }}

{{/*
Selector labels
*/}}
{{- define "pi-hole.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pi-hole.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "pi-hole.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "pi-hole.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the proper pi-hole image name
*/}}
{{- define "pi-hole.image" -}}
{{ include "shared.images.image" (dict "imageRoot" .Values.image "global" .Values.global "appVersion" .Chart.AppVersion) }}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "shared.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "shared.tplvalues.render" -}}
  {{- if typeIs "string" .value }}
    {{- tpl .value .context }}
  {{- else }}
    {{- tpl (.value | toYaml) .context }}
  {{- end }}
{{- end -}}

{{/*
Return the proper image name
{{ include "shared.images.image" ( dict "imageRoot" .Values.path.to.the.image "global" $) }}
*/}}
{{- define "shared.images.image" -}}
{{- $registryName := .imageRoot.registry -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $tag := .imageRoot.tag | toString -}}
{{- if eq $tag "" }} 
  {{- $tag = .appVersion | toString -}}
{{- end }}
{{- if .global }}
  {{- if .global.image }}
    {{- if .global.image.registry }}
      {{- $registryName = .global.image.registry -}}
    {{- end }}
    {{- if .global.image.repository }}
      {{- $repositoryName = .global.image.repository -}}
    {{- end }}
    {{- if .global.image.tag }}
      {{- $tag = .global.image.tag | toString -}}
    {{- end }}
  {{- end }}
{{- end }}
{{- if $registryName }}
  {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- else }}
  {{- printf "%s:%s" $repositoryName $tag -}}
{{- end }}
{{- end -}}
