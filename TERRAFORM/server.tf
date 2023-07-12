data "http" "upgrad-rakesh-myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "upgrad-rakesh-sg-ssh" {
  name        = "upgrad-rakesh-sg-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.upgrad-rakesh-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.upgrad-rakesh-myip.response_body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "upgrad-rakesh-sg-ssh"
  }
}

resource "aws_security_group" "upgrad-rakesh-sg-alltraffic" {
  name        = "upgrad-rakesh-sg-alltraffic"
  description = "Allow All VPC Traffic"
  vpc_id      = aws_vpc.upgrad-rakesh-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.upgrad-rakesh-vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "upgrad-rakesh-sg-alltraffic"
  }
}

resource "aws_security_group" "upgrad-rakesh-sg-http" {
  name        = "upgrad-rakesh-sg-http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.upgrad-rakesh-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.upgrad-rakesh-myip.response_body)}/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${(aws_instance.upgrad-rakesh-ec2-bashtion.private_ip)}/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.upgrad-rakesh-myip.response_body)}/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${(aws_instance.upgrad-rakesh-ec2-bashtion.private_ip)}/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${(aws_instance.upgrad-rakesh-ec2-jenkins.private_ip)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "upgrad-rakesh-sg-http"
  }
}

resource "aws_key_pair" "upgrad-capstone-keypair" {
  key_name   = "upgrad-capstone-keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDd9PYcJiHWv0r1aZTmDX5lWYNnyV+e83G/aG0qsTdRv6EgzYHMHWioHoSZPmcp7Y1/N6SJ5G5kJt4NAoP9/dey76GzlEYY1eu5V9bRHXgOD+oyPm9EVwgwa699RNgboMzlE+WabWRg4MToXnwlvwr1Jd8GiAAV6D6zd73oFHB5LAdhnNRhXRKNAov6dnTCMpzOLSFKpzE938MzuwNJn29BdPddH6f6wuKelSzh1Urr2O+bXsdrf4osu+oSbIdvZxowyj6RfVAzNVrz5TMrVsM2B5QMg7UmLzO3WfdcX6VwNM3X8VPGn8yh53W2fz4tNfTr4wzsYnI3LYcQM91s5BfKx6RrCdt3aZnnxWLwIqiPEbVsks6xPf95J0a0/Rz0UXUSxGQ17TN5b0TYatHNyJZOqZCSnSNBKeoBnJA/ewzHaegaYBOnQ28GNI2FoO6Pd5ZEr4DAycQKn0px9boyachroAehgXcpljYHxUY6UMbrR1xuxg6RRFZHhaK4+bO0DkPkTCI4XeeIHKjA3j9Kz548iOT1Z9QM9JAx8zh4J+EEewUvpFxXEl95FTjj5kX9XqCaQAaIxJLIejckp6haFlHW+8kd4og+YeqTyD6ccDD3eukZulmnT+W5DcvFm2TDYaBT5TUalqNAhTYtZOQmHRjzstPE4liVnmyKlOSb6artQ== ubuntu@ip-172-31-84-55"
}

resource "aws_instance" "upgrad-rakesh-ec2-bashtion" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.upgrad-capstone-keypair.key_name
  subnet_id                   = aws_subnet.upgrad-rakesh-subnet-pb-a.id
  vpc_security_group_ids      = [aws_security_group.upgrad-rakesh-sg-ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = "upgrad-rakesh-ec2-bashtion"
  }
}

resource "aws_instance" "upgrad-rakesh-ec2-jenkins" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.upgrad-capstone-keypair.key_name
  subnet_id                   = aws_subnet.upgrad-rakesh-subnet-pt-a.id
  vpc_security_group_ids      = [aws_security_group.upgrad-rakesh-sg-alltraffic.id]
  associate_public_ip_address = false

  tags = {
    Name = "upgrad-rakesh-ec2-jenkins"
  }
}

resource "aws_instance" "upgrad-rakesh-ec2-app" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.upgrad-capstone-keypair.key_name
  subnet_id                   = aws_subnet.upgrad-rakesh-subnet-pb-b.id
  vpc_security_group_ids      = [aws_security_group.upgrad-rakesh-sg-http.id]
  associate_public_ip_address = false

  tags = {
    Name = "upgrad-rakesh-ec2-app"
  }
}