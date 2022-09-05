# Include this file as a CLI argument with -var
# OR
# Rename to terraform.tfvars
creds = {
  region = "<Choose your Region>"
  access = "<Access_Key>"
  secret = "<Secret_Key>"
}

domain = "<Your_Domain>" # expects to have route53 already configured with your domain with base hosted zone

addressing = {
  networks = {
    vpc     = "<VPC_Subnet>/16"
    public  = "<Public_Subnet>/24"
    private = "<Private_Subnet>/24"
  }
  hosts = {
    jumpbox    = "<Private_Address_of_Bastion_Host>"
    datastream = "<Private_Address_of_Datastream_Host>"
    home       = "<Host_You_Want_Access_From>/32" # public wan address of where you're coming from
  }
}

