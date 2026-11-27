variable "yc_token" {
  type        = string
  description = "OAuth-токен Яндекс.Облака"
  sensitive   = true
}

variable "yc_cloud_id" {
  type        = string
  description = "ID облака Яндекс.Облака"
}

variable "yc_folder_id" {
  type        = string
  description = "ID каталога Яндекс.Облака"
}
