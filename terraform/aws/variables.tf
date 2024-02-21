variable "upload_directory" {
  default = "../../website/"
}

variable "mime_types" {
  default = {
    htm  = "text/html"
    html = "text/html"
    css  = "text/css"
    svg  = "image/svg+xml"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
    png  = "image/png"
    ttf  = "font/ttf"
    js   = "application/javascript"
    map  = "application/javascript"
    json = "application/json"
  }
}
