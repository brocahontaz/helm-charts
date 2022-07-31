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
