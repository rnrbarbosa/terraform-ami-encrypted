#------------------------------------------------------------
# Use your SSH Keys (optional)
#------------------------------------------------------------
 variable "PATH_TO_PRIVATE_KEY" {
   default = "../key/mykey"
 }

 variable "PATH_TO_PUBLIC_KEY" {
   default = "../key/mykey.pub"
 }

 resource "aws_key_pair" "key" {
   key_name   = "temp"
   public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"

   lifecycle {
     ignore_changes = ["public_key"]
   }
 }
