{{- define "nautobot.configMap.env" -}}
NAUTOBOT_ALLOWED_HOSTS: {{ .Values.nautobot.allowedHosts | quote }}
{{- if .Values.nautobot.superUser.enabled }}
NAUTOBOT_CREATE_SUPERUSER: "true"
{{- else }}
NAUTOBOT_CREATE_SUPERUSER: "false"
{{- end }}

{{- if .Values.nautobot.debug }}
NAUTOBOT_DEBUG: "True"
{{- else }}
NAUTOBOT_DEBUG: "False"
{{- end }}
NAUTOBOT_LOG_LEVEL: {{ .Values.nautobot.logLevel | quote }}
{{- if or .Values.nautobot.metrics .Values.metrics.enabled }}
NAUTOBOT_METRICS_ENABLED: "True"
{{- else }}
NAUTOBOT_METRICS_ENABLED: "False"
{{- end }}
{{- if .Values.nautobot.superUser.enabled }}
NAUTOBOT_SUPERUSER_EMAIL: {{ .Values.nautobot.superUser.email | quote }}
NAUTOBOT_SUPERUSER_NAME: {{ .Values.nautobot.superUser.username | quote }}
{{- end }}
{{- if .Values.celery.celery_health_probes_as_files }}
NAUTOBOT_CELERY_HEALTH_PROBES_AS_FILES: "True"
{{- end }}
{{- if eq (include "nautobot.kubernetesJobsEnabled" $) "true" }}
NAUTOBOT_JOB_QUEUE_PATH: {{ .Values.nautobot.jobsManifestsMountPath | quote }}
NAUTOBOT_KUBERNETES_JOB_POD_NAMESPACE: {{ .Release.Namespace | quote }}
{{- end }}
{{- if .Values.nautobot.extraVars }}
{{- range .Values.nautobot.extraVars }}
{{ .name }}: {{ .value | quote }}
{{- end }}
{{- end }}
{{ end }}

{{- define "nautobot.configMap.config" -}}
{{- if .Values.nautobot.config }}
nautobot_config.py: |
{{- .Values.nautobot.config | nindent 2 }}
{{- end }}
uwsgi.ini: |
{{- if .Values.nautobot.uWSGIini }}
{{- .Values.nautobot.uWSGIini | nindent 2 }}
{{- else }}
{{- include "nautobot.uwsgi.ini" . | nindent 2 }}
{{- end }}
{{- end }}
