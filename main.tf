resource "aws_instance" "ec2-vm" {
  ami           = "ami-03a933af70fa97ad2"
  instance_type = "t3.medium"
  key_name   = "ansibleterra"
  user_data = <<-EOF
     #!/bin/bash
     sudo apt update -y
     sudo apt install ansible -y
     EOF

  tags = {
    Name = "ec2-vm"
  }
}

resource "time_sleep" "wait_90_seconds" {
  depends_on = [ aws_instance.ec2-vm ]
  create_duration = "90s"
  
}

resource "null_resource" "copyps1" {
  depends_on = [time_sleep.wait_90_seconds]
  connection {
  type        = "ssh"
  host        = aws_instance.ec2-vm.public_ip
  user        = "ubuntu"
  timeout     = "5m"
  private_key = file("ansibleterra.pem")
  
  }

  provisioner "file" {
    source      = "ansiblejavajenkinsauto.yml"
    destination = "/tmp/ansiblejavajenkinsauto.yml"
    on_failure = fail
  }
  
  
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /tmp/ansiblejavajenkinsauto.yml",
      "cd /tmp ",
      "ansible-playbook /tmp/ansiblejavajenkinsauto.yml"
      
    ]
  }
}


