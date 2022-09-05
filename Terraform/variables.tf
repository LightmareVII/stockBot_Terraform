variable "creds" {
  type = object({
    region = string,
    access = string,
    secret = string
  })
}

variable "domain" {
  type = string
}

variable "addressing" {
  type = object({
    networks = object({
      vpc     = string
      public  = string
      private = string
    })
    hosts = object({
      jumpbox    = string
      datastream = string
      home       = string
    })
  })
}

variable "rules" {
  type = object({
    private = object({
      ingress = list(object({
        description = string
        from_port   = number
        to_port     = number
        protocol    = string
      }))
    })
    public = object({
      ingress = list(object({
        description = string
        from_port   = number
        to_port     = number
        protocol    = string
      }))
    })
  })
}