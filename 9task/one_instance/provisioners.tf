resource "null_resource" "connect_public" {
  connection {
    type        = "ssh"
    host        = aws_instance.server.public_ip
    user         = var.EC2_USER
  }

  provisioner "remote-exec" {
    inline = ["echo 'CONNECTED to PUBLIC!'"]
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