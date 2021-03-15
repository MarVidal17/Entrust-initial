
resource "null_resource" "connect_bastion" {
  connection {
    type        = "ssh"
    host        = aws_instance.bastion.public_ip
    user        = var.EC2_USER
  }

  provisioner "remote-exec" {
    inline = ["echo 'CONNECTED to BASTION!'"]
  }
}

resource "null_resource" "connect_private" {
  connection {
    bastion_host = aws_instance.bastion.public_ip
    host         = aws_instance.server.private_ip
    user         = var.EC2_USER
  }

  provisioner "remote-exec" {
    inline = ["echo 'CONNECTED to PRIVATE!'"]
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir ~/app",
      "mkdir ~/scripts"
    ]
  }

  provisioner "file" {
    source = "./files/server.go"
    destination = "~/app/server.go"
  }

  provisioner "file" {
    source = "./scripts/"
    destination = "~/scripts"
  }

  provisioner "remote-exec" {
    inline = [
      "sh ~/scripts/install-docker-aws-linux2.sh"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sh ~/scripts/build-docker-image.sh"
    ]
  }
}